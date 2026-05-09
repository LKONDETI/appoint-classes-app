namespace ApptApi.Application.DTOs.Auth;

public record RegisterRequest(string DisplayName, string Email, string Password);
