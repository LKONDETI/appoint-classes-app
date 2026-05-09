namespace ApptApi.Application.DTOs.Profile;

public record UpdateProfileRequest(string DisplayName, string? PhoneNumber, string? Bio, string? AvatarUrl);
