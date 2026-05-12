using ApptApi.Domain.Common;

namespace ApptApi.Domain.Entities;

public class Class : BaseEntity
{
    public string Title { get; private set; } = string.Empty;
    public Guid ProviderId { get; private set; }
    public Provider Provider { get; private set; } = null!;
    public DateTime ScheduledAt { get; private set; }
    public int DurationMinutes { get; private set; }
    public int MaxCapacity { get; private set; }
    public string? Description { get; private set; }
    public ICollection<Booking> Bookings { get; private set; } = [];

    private Class() { }

    public static Class Create(
        string title,
        Guid providerId,
        DateTime scheduledAt,
        int durationMinutes,
        int maxCapacity,
        string? description)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(title);
        ArgumentOutOfRangeException.ThrowIfNegativeOrZero(durationMinutes);
        ArgumentOutOfRangeException.ThrowIfNegativeOrZero(maxCapacity);

        return new Class
        {
            Title = title,
            ProviderId = providerId,
            ScheduledAt = scheduledAt,
            DurationMinutes = durationMinutes,
            MaxCapacity = maxCapacity,
            Description = description
        };
    }
}
