using ApptApi.Domain.Entities;

namespace ApptApi.Application.Services.Interfaces;

public interface IJwtTokenService
{
    (string Token, DateTime ExpiresAt) GenerateToken(User user, string displayName);
}
