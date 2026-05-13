using ApptApi.Domain.Entities;
using ApptApi.Domain.Interfaces;
using ApptApi.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace ApptApi.Infrastructure.Repositories;

public class ClassRepository : IClassRepository
{
    private readonly AppDbContext _db;

    public ClassRepository(AppDbContext db) => _db = db;

    public async Task<IReadOnlyList<Class>> GetUpcomingAsync(int limit, CancellationToken ct = default) =>
        await _db.Classes
            .Include(c => c.Provider)
            .Include(c => c.Bookings.Where(b => b.Status == BookingStatus.Confirmed))
            .Where(c => c.ScheduledAt > DateTime.UtcNow)
            .OrderBy(c => c.ScheduledAt)
            .Take(limit)
            .ToListAsync(ct);

    public Task<Class?> GetByIdAsync(Guid id, CancellationToken ct = default) =>
        _db.Classes
            .Include(c => c.Bookings.Where(b => b.Status == BookingStatus.Confirmed))
            .FirstOrDefaultAsync(c => c.Id == id, ct);

    public Task SaveChangesAsync(CancellationToken ct = default) =>
        _db.SaveChangesAsync(ct);
}
