using ApptApi.Application.DTOs.Classes;
using ApptApi.Application.Services.Interfaces;
using ApptApi.Domain.Entities;
using ApptApi.Domain.Interfaces;

namespace ApptApi.Application.Services;

public class ClassService : IClassService
{
    private readonly IClassRepository _classRepo;

    public ClassService(IClassRepository classRepo)
    {
        _classRepo = classRepo;
    }

    public async Task<IReadOnlyList<ClassResponse>> GetUpcomingAsync(int limit = 10, CancellationToken ct = default)
    {
        var classes = await _classRepo.GetUpcomingAsync(limit, ct);
        return classes.Select(ToResponse).ToList();
    }

    private static ClassResponse ToResponse(Class c) =>
        new(
            c.Id,
            c.Title,
            new ProviderSummaryDto(c.Provider.Id, c.Provider.Name, c.Provider.AvatarUrl, c.Provider.Specialty),
            c.ScheduledAt,
            c.DurationMinutes,
            c.MaxCapacity,
            c.Bookings.Count(b => b.Status == BookingStatus.Confirmed),
            c.Description);
}
