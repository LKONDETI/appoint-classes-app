namespace ApptApi.Application.DTOs.Classes;

public record ProviderSummaryDto(
    Guid Id,
    string Name,
    string? AvatarUrl,
    string? Specialty);

public record ClassResponse(
    Guid Id,
    string Title,
    ProviderSummaryDto Provider,
    DateTime ScheduledAt,
    int DurationMinutes,
    int MaxCapacity,
    int BookedCount,
    string? Description);
