using ApptApi.Domain.Common;

namespace ApptApi.Domain.Entities;

public class UserProfile : BaseEntity
{
    public Guid UserId { get; private set; }
    public string DisplayName { get; private set; } = string.Empty;
    public string? AvatarUrl { get; private set; }
    public string? PhoneNumber { get; private set; }
    public string? Bio { get; private set; }
    public User User { get; private set; } = null!;

    private UserProfile() { }

    public static UserProfile Create(Guid userId, string displayName)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(displayName);

        return new UserProfile
        {
            UserId = userId,
            DisplayName = displayName
        };
    }

    public void Update(string displayName, string? phoneNumber, string? bio)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(displayName);
        DisplayName = displayName;
        PhoneNumber = phoneNumber;
        Bio = bio;
        Touch();
    }

    public void SetAvatarUrl(string? url)
    {
        AvatarUrl = url;
        Touch();
    }
}
