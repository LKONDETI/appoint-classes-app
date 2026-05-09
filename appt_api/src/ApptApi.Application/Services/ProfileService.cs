using ApptApi.Application.Common;
using ApptApi.Application.DTOs.Profile;
using ApptApi.Application.Services.Interfaces;
using ApptApi.Domain.Interfaces;

namespace ApptApi.Application.Services;

public class ProfileService : IProfileService
{
    private readonly IUserProfileRepository _profileRepo;
    private readonly IUserRepository _userRepo;

    public ProfileService(IUserProfileRepository profileRepo, IUserRepository userRepo)
    {
        _profileRepo = profileRepo;
        _userRepo = userRepo;
    }

    public async Task<ProfileResponse> GetByUserIdAsync(Guid userId, CancellationToken ct = default)
    {
        var user = await _userRepo.GetByIdAsync(userId, ct)
            ?? throw new NotFoundException("USER_NOT_FOUND", "User not found.");

        var profile = await _profileRepo.GetByUserIdAsync(userId, ct)
            ?? throw new NotFoundException("PROFILE_NOT_FOUND", "Profile not found.");

        return ToResponse(profile, user.Email);
    }

    public async Task<ProfileResponse> UpdateAsync(Guid userId, UpdateProfileRequest request, CancellationToken ct = default)
    {
        var user = await _userRepo.GetByIdAsync(userId, ct)
            ?? throw new NotFoundException("USER_NOT_FOUND", "User not found.");

        var profile = await _profileRepo.GetByUserIdAsync(userId, ct)
            ?? throw new NotFoundException("PROFILE_NOT_FOUND", "Profile not found.");

        profile.Update(request.DisplayName, request.PhoneNumber, request.Bio);
        if (request.AvatarUrl is not null)
            profile.SetAvatarUrl(request.AvatarUrl);
        await _profileRepo.SaveChangesAsync(ct);

        return ToResponse(profile, user.Email);
    }

    private static ProfileResponse ToResponse(Domain.Entities.UserProfile profile, string email) =>
        new(
            profile.Id,
            profile.UserId,
            email,
            profile.DisplayName,
            profile.AvatarUrl,
            profile.PhoneNumber,
            profile.Bio,
            profile.CreatedAt,
            profile.UpdatedAt);
}
