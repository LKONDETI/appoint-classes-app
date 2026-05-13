using ApptApi.Application.Common;
using ApptApi.Application.DTOs.Bookings;
using ApptApi.Application.Services.Interfaces;
using ApptApi.Domain.Entities;
using ApptApi.Domain.Interfaces;

namespace ApptApi.Application.Services;

public class BookingService : IBookingService
{
    private readonly IBookingRepository _bookingRepo;
    private readonly IClassRepository _classRepo;

    public BookingService(IBookingRepository bookingRepo, IClassRepository classRepo)
    {
        _bookingRepo = bookingRepo;
        _classRepo = classRepo;
    }

    public async Task<BookingResponse> CreateAsync(Guid userId, CreateBookingRequest request, CancellationToken ct = default)
    {
        var @class = await _classRepo.GetByIdAsync(request.ClassId, ct)
            ?? throw new NotFoundException("CLASS_NOT_FOUND", "Class not found.");

        var alreadyBooked = await _bookingRepo.ExistsAsync(userId, request.ClassId, ct);
        if (alreadyBooked)
            throw new ConflictException("ALREADY_BOOKED", "You have already booked this class.");

        var bookedCount = @class.Bookings.Count(b => b.Status == BookingStatus.Confirmed);
        if (bookedCount >= @class.MaxCapacity)
            throw new ConflictException("CLASS_FULL", "This class is at full capacity.");

        var booking = Booking.Create(userId, request.ClassId);
        await _bookingRepo.AddAsync(booking, ct);
        await _bookingRepo.SaveChangesAsync(ct);

        return ToResponse(booking, @class);
    }

    public async Task<IReadOnlyList<BookingResponse>> GetMyBookingsAsync(Guid userId, CancellationToken ct = default)
    {
        var bookings = await _bookingRepo.GetByUserIdAsync(userId, ct);
        return bookings.Select(b => ToResponse(b, b.Class)).ToList();
    }

    private static BookingResponse ToResponse(Booking booking, Class @class) =>
        new(
            booking.Id,
            booking.ClassId,
            @class.Title,
            @class.ScheduledAt,
            booking.BookedAt,
            booking.Status.ToString());
}
