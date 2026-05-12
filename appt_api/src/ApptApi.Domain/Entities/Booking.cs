using ApptApi.Domain.Common;

namespace ApptApi.Domain.Entities;

public enum BookingStatus
{
    Confirmed,
    Cancelled
}

public class Booking : BaseEntity
{
    public Guid UserId { get; private set; }
    public User User { get; private set; } = null!;
    public Guid ClassId { get; private set; }
    public Class Class { get; private set; } = null!;
    public DateTime BookedAt { get; private set; }
    public BookingStatus Status { get; private set; }

    private Booking() { }

    public static Booking Create(Guid userId, Guid classId)
    {
        return new Booking
        {
            UserId = userId,
            ClassId = classId,
            BookedAt = DateTime.UtcNow,
            Status = BookingStatus.Confirmed
        };
    }

    public void Cancel()
    {
        Status = BookingStatus.Cancelled;
        Touch();
    }
}
