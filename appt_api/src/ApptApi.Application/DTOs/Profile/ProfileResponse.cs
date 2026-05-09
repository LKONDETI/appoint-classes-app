namespace ApptApi.Application.DTOs.Profile;

public record ProfileResponse(
    Guid Id,
    Guid UserId,
    string Email,
    string DisplayName,
    string? AvatarUrl,
    string? PhoneNumber,
    string? Bio,
    DateTime CreatedAt,
    DateTime UpdatedAt);
