using ApptApi.Domain.Common;

namespace ApptApi.Domain.Entities;

public class User : BaseEntity
{
    public string Email { get; private set; } = string.Empty;
    public string? PasswordHash { get; private set; }
    public string Provider { get; private set; } = "email";
    public string? ProviderId { get; private set; }
    public bool IsActive { get; private set; } = true;
    public UserProfile? Profile { get; private set; }

    private User() { }

    public static User Create(string email, string passwordHash)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(email);
        ArgumentException.ThrowIfNullOrWhiteSpace(passwordHash);

        return new User
        {
            Email = email.ToLowerInvariant(),
            PasswordHash = passwordHash,
            Provider = "email"
        };
    }

    public static User CreateSocialUser(string email, string provider, string providerId)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(email);
        ArgumentException.ThrowIfNullOrWhiteSpace(provider);
        ArgumentException.ThrowIfNullOrWhiteSpace(providerId);

        return new User
        {
            Email = email.ToLowerInvariant(),
            Provider = provider,
            ProviderId = providerId
        };
    }

    public void SetProfile(UserProfile profile)
    {
        Profile = profile;
        Touch();
    }

    public void Deactivate()
    {
        IsActive = false;
        Touch();
    }
}
