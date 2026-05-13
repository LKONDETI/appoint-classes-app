namespace ApptApi.Application.DTOs.Bookings;

public record BookingResponse(
    Guid Id,
    Guid ClassId,
    string ClassTitle,
    DateTime ScheduledAt,
    DateTime BookedAt,
    string Status);
