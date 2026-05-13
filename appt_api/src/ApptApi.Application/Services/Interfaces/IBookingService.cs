using ApptApi.Application.DTOs.Bookings;

namespace ApptApi.Application.Services.Interfaces;

public interface IBookingService
{
    Task<BookingResponse> CreateAsync(Guid userId, CreateBookingRequest request, CancellationToken ct = default);
    Task<IReadOnlyList<BookingResponse>> GetMyBookingsAsync(Guid userId, CancellationToken ct = default);
}
