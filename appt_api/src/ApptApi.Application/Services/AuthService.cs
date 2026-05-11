using ApptApi.Application.Common;
using ApptApi.Application.DTOs.Auth;
using ApptApi.Application.Services.Interfaces;
using ApptApi.Domain.Entities;
using ApptApi.Domain.Interfaces;

namespace ApptApi.Application.Services;

public class AuthService : IAuthService
{
    private readonly IUserRepository _userRepo;
    private readonly IUserProfileRepository _profileRepo;
    private readonly IJwtTokenService _jwtService;
    private readonly IGoogleTokenVerifier _googleVerifier;

    public AuthService(
        IUserRepository userRepo,
        IUserProfileRepository profileRepo,
        IJwtTokenService jwtService,
        IGoogleTokenVerifier googleVerifier)
    {
        _userRepo = userRepo;
        _profileRepo = profileRepo;
        _jwtService = jwtService;
        _googleVerifier = googleVerifier;
    }

    public async Task<AuthResponse> RegisterAsync(RegisterRequest request, CancellationToken ct = default)
    {
        if (await _userRepo.ExistsByEmailAsync(request.Email, ct))
            throw new ConflictException("EMAIL_ALREADY_EXISTS", "An account with this email already exists.");

        var passwordHash = BCrypt.Net.BCrypt.HashPassword(request.Password, workFactor: 12);
        var user = User.Create(request.Email, passwordHash);

        await _userRepo.AddAsync(user, ct);

        var profile = UserProfile.Create(user.Id, request.DisplayName);
        await _profileRepo.AddAsync(profile, ct);

        await _userRepo.SaveChangesAsync(ct);

        var (token, expiresAt) = _jwtService.GenerateToken(user, request.DisplayName);

        return new AuthResponse(
            token,
            expiresAt,
            new AuthUserDto(user.Id, user.Email, request.DisplayName));
    }

    public async Task<AuthResponse> LoginAsync(LoginRequest request, CancellationToken ct = default)
    {
        var user = await _userRepo.GetByEmailAsync(request.Email, ct)
            ?? throw new UnauthorizedException("INVALID_CREDENTIALS", "Email or password is incorrect.");

        if (user.PasswordHash is null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
            throw new UnauthorizedException("INVALID_CREDENTIALS", "Email or password is incorrect.");

        var displayName = user.Profile?.DisplayName ?? user.Email;
        var (token, expiresAt) = _jwtService.GenerateToken(user, displayName);

        return new AuthResponse(
            token,
            expiresAt,
            new AuthUserDto(user.Id, user.Email, displayName));
    }

    public async Task<AuthResponse> SocialAuthAsync(SocialAuthRequest request, CancellationToken ct = default)
    {
        if (request.Provider != "google")
            throw new AppException("UNSUPPORTED_PROVIDER", $"Provider '{request.Provider}' is not supported.");

        var payload = await _googleVerifier.VerifyAsync(request.IdToken, ct);

        if (!payload.EmailVerified)
            throw new UnauthorizedException("EMAIL_NOT_VERIFIED", "Google account email is not verified.");

        var user = await _userRepo.GetByProviderIdAsync(request.Provider, payload.Sub, ct);

        if (user is null)
        {
            var existingByEmail = await _userRepo.GetByEmailAsync(payload.Email, ct);
            if (existingByEmail is not null)
                throw new ConflictException(
                    "EMAIL_ALREADY_EXISTS",
                    "An account with this email already exists. Please sign in with your email and password.");

            user = User.CreateSocialUser(payload.Email, request.Provider, payload.Sub);
            await _userRepo.AddAsync(user, ct);

            var displayName = payload.Name ?? payload.Email.Split('@')[0];
            var profile = UserProfile.Create(user.Id, displayName);
            await _profileRepo.AddAsync(profile, ct);

            await _userRepo.SaveChangesAsync(ct);
        }

        var name = user.Profile?.DisplayName ?? payload.Name ?? user.Email.Split('@')[0];
        var (token, expiresAt) = _jwtService.GenerateToken(user, name);

        return new AuthResponse(token, expiresAt, new AuthUserDto(user.Id, user.Email, name));
    }
}
