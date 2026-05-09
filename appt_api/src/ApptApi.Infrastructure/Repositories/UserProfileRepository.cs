using ApptApi.Domain.Entities;
using ApptApi.Domain.Interfaces;
using ApptApi.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace ApptApi.Infrastructure.Repositories;

public class UserProfileRepository : IUserProfileRepository
{
    private readonly AppDbContext _db;

    public UserProfileRepository(AppDbContext db) => _db = db;

    public Task<UserProfile?> GetByUserIdAsync(Guid userId, CancellationToken ct = default) =>
        _db.UserProfiles.FirstOrDefaultAsync(p => p.UserId == userId, ct);

    public async Task AddAsync(UserProfile profile, CancellationToken ct = default) =>
        await _db.UserProfiles.AddAsync(profile, ct);

    public Task SaveChangesAsync(CancellationToken ct = default) =>
        _db.SaveChangesAsync(ct);
}
