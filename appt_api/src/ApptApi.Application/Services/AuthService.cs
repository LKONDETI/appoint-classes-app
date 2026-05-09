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

    public AuthService(
        IUserRepository userRepo,
        IUserProfileRepository profileRepo,
        IJwtTokenService jwtService)
    {
        _userRepo = userRepo;
        _profileRepo = profileRepo;
        _jwtService = jwtService;
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

        if (!BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
            throw new UnauthorizedException("INVALID_CREDENTIALS", "Email or password is incorrect.");

        var displayName = user.Profile?.DisplayName ?? user.Email;
        var (token, expiresAt) = _jwtService.GenerateToken(user, displayName);

        return new AuthResponse(
            token,
            expiresAt,
            new AuthUserDto(user.Id, user.Email, displayName));
    }
}
