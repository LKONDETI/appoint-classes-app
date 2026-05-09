using ApptApi.Application.DTOs.Profile;
using FluentValidation;

namespace ApptApi.API.Validators;

public class UpdateProfileRequestValidator : AbstractValidator<UpdateProfileRequest>
{
    public UpdateProfileRequestValidator()
    {
        RuleFor(x => x.DisplayName).NotEmpty().MaximumLength(100);
        RuleFor(x => x.PhoneNumber).MaximumLength(30).When(x => x.PhoneNumber is not null);
        RuleFor(x => x.Bio).MaximumLength(500).When(x => x.Bio is not null);
    }
}
