using ApptApi.Application.DTOs.Classes;

namespace ApptApi.Application.Services.Interfaces;

public interface IClassService
{
    Task<IReadOnlyList<ClassResponse>> GetUpcomingAsync(int limit = 10, CancellationToken ct = default);
}
