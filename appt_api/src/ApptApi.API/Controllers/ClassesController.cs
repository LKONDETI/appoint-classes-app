using ApptApi.Application.DTOs.Classes;
using ApptApi.Application.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace ApptApi.API.Controllers;

[ApiController]
[Route("api/classes")]
public class ClassesController : ControllerBase
{
    private readonly IClassService _classService;

    public ClassesController(IClassService classService) => _classService = classService;

    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyList<ClassResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetUpcoming([FromQuery] int limit = 10, CancellationToken ct = default)
    {
        var clamped = Math.Clamp(limit, 1, 50);
        var result = await _classService.GetUpcomingAsync(clamped, ct);
        return Ok(result);
    }
}
