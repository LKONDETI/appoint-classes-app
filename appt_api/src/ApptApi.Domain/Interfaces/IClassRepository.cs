using ApptApi.Domain.Entities;

namespace ApptApi.Domain.Interfaces;

public interface IClassRepository
{
    Task<IReadOnlyList<Class>> GetUpcomingAsync(int limit, CancellationToken ct = default);
    Task<Class?> GetByIdAsync(Guid id, CancellationToken ct = default);
    Task SaveChangesAsync(CancellationToken ct = default);
}
