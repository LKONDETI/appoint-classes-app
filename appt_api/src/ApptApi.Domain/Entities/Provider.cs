using ApptApi.Domain.Common;

namespace ApptApi.Domain.Entities;

public class Provider : BaseEntity
{
    public string Name { get; private set; } = string.Empty;
    public string? Bio { get; private set; }
    public string? AvatarUrl { get; private set; }
    public string? Specialty { get; private set; }
    public ICollection<Class> Classes { get; private set; } = [];

    private Provider() { }

    public static Provider Create(string name, string? bio, string? avatarUrl, string? specialty)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);

        return new Provider
        {
            Name = name,
            Bio = bio,
            AvatarUrl = avatarUrl,
            Specialty = specialty
        };
    }
}
