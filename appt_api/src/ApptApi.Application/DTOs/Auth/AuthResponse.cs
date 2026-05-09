namespace ApptApi.Application.DTOs.Auth;

public record AuthResponse(
    string Token,
    DateTime ExpiresAt,
    AuthUserDto User);

public record AuthUserDto(Guid Id, string Email, string DisplayName);
