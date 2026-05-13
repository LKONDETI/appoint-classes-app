using ApptApi.Domain.Entities;
using ApptApi.Domain.Interfaces;
using ApptApi.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace ApptApi.Infrastructure.Repositories;

public class BookingRepository : IBookingRepository
{
    private readonly AppDbContext _db;

    public BookingRepository(AppDbContext db) => _db = db;

    public async Task<IReadOnlyList<Booking>> GetByUserIdAsync(Guid userId, CancellationToken ct = default) =>
        await _db.Bookings
            .Include(b => b.Class)
            .Where(b => b.UserId == userId)
            .OrderByDescending(b => b.BookedAt)
            .ToListAsync(ct);

    public Task<bool> ExistsAsync(Guid userId, Guid classId, CancellationToken ct = default) =>
        _db.Bookings.AnyAsync(
            b => b.UserId == userId && b.ClassId == classId && b.Status == BookingStatus.Confirmed,
            ct);

    public async Task AddAsync(Booking booking, CancellationToken ct = default) =>
        await _db.Bookings.AddAsync(booking, ct);

    public Task SaveChangesAsync(CancellationToken ct = default) =>
        _db.SaveChangesAsync(ct);
}
