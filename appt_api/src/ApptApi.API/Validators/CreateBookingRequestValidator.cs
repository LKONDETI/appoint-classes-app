using ApptApi.Application.DTOs.Bookings;
using FluentValidation;

namespace ApptApi.API.Validators;

public class CreateBookingRequestValidator : AbstractValidator<CreateBookingRequest>
{
    public CreateBookingRequestValidator()
    {
        RuleFor(x => x.ClassId).NotEmpty();
    }
}
