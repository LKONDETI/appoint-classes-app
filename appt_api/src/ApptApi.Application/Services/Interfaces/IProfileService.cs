using ApptApi.Application.DTOs.Profile;

namespace ApptApi.Application.Services.Interfaces;

public interface IProfileService
{
    Task<ProfileResponse> GetByUserIdAsync(Guid userId, CancellationToken ct = default);
    Task<ProfileResponse> UpdateAsync(Guid userId, UpdateProfileRequest request, CancellationToken ct = default);
}
