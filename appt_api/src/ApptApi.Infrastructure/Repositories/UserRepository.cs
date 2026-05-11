using ApptApi.Domain.Entities;
using ApptApi.Domain.Interfaces;
using ApptApi.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace ApptApi.Infrastructure.Repositories;

public class UserRepository : IUserRepository
{
    private readonly AppDbContext _db;

    public UserRepository(AppDbContext db) => _db = db;

    public Task<User?> GetByIdAsync(Guid id, CancellationToken ct = default) =>
        _db.Users.Include(u => u.Profile).FirstOrDefaultAsync(u => u.Id == id, ct);

    public Task<User?> GetByEmailAsync(string email, CancellationToken ct = default) =>
        _db.Users.Include(u => u.Profile).FirstOrDefaultAsync(u => u.Email == email.ToLowerInvariant(), ct);

    public Task<bool> ExistsByEmailAsync(string email, CancellationToken ct = default) =>
        _db.Users.AnyAsync(u => u.Email == email.ToLowerInvariant(), ct);

    public Task<User?> GetByProviderIdAsync(string provider, string providerId, CancellationToken ct = default) =>
        _db.Users.Include(u => u.Profile).FirstOrDefaultAsync(u => u.Provider == provider && u.ProviderId == providerId, ct);

    public async Task AddAsync(User user, CancellationToken ct = default) =>
        await _db.Users.AddAsync(user, ct);

    public Task SaveChangesAsync(CancellationToken ct = default) =>
        _db.SaveChangesAsync(ct);
}
