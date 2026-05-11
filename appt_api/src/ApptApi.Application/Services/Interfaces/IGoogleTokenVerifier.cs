namespace ApptApi.Application.Services.Interfaces;

public record GoogleTokenPayload(
    string Sub,
    string Email,
    string? Name,
    string? Picture,
    bool EmailVerified);

public interface IGoogleTokenVerifier
{
    Task<GoogleTokenPayload> VerifyAsync(string idToken, CancellationToken ct = default);
}
