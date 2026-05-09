using ApptApi.Domain.Common;

namespace ApptApi.Domain.Entities;

public class User : BaseEntity
{
    public string Email { get; private set; } = string.Empty;
    public string PasswordHash { get; private set; } = string.Empty;
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
            PasswordHash = passwordHash
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
