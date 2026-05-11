using ApptApi.Application.Common;
using ApptApi.Application.Services.Interfaces;
using Google.Apis.Auth;
using Microsoft.Extensions.Options;

namespace ApptApi.Infrastructure.Services;

public class GoogleTokenVerifier : IGoogleTokenVerifier
{
    private readonly GoogleSettings _settings;

    public GoogleTokenVerifier(IOptions<GoogleSettings> settings)
        => _settings = settings.Value;

    public async Task<GoogleTokenPayload> VerifyAsync(string idToken, CancellationToken ct = default)
    {
        try
        {
            var settings = new GoogleJsonWebSignature.ValidationSettings
            {
                Audience = [_settings.ClientId]
            };

            var payload = await GoogleJsonWebSignature.ValidateAsync(idToken, settings);

            return new GoogleTokenPayload(
                Sub: payload.Subject,
                Email: payload.Email,
                Name: payload.Name,
                Picture: payload.Picture,
                EmailVerified: payload.EmailVerified);
        }
        catch (InvalidJwtException ex)
        {
            throw new UnauthorizedException("INVALID_GOOGLE_TOKEN", $"Google token validation failed: {ex.Message}");
        }
    }
}
