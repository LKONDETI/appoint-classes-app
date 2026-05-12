using ApptApi.Domain.Entities;

namespace ApptApi.Domain.Interfaces;

public interface IBookingRepository
{
    Task<IReadOnlyList<Booking>> GetByUserIdAsync(Guid userId, CancellationToken ct = default);
    Task<bool> ExistsAsync(Guid userId, Guid classId, CancellationToken ct = default);
    Task AddAsync(Booking booking, CancellationToken ct = default);
    Task SaveChangesAsync(CancellationToken ct = default);
}
