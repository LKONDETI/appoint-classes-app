using ApptApi.Application.DTOs.Auth;
using FluentValidation;

namespace ApptApi.API.Validators;

public class SocialAuthRequestValidator : AbstractValidator<SocialAuthRequest>
{
    private static readonly string[] SupportedProviders = ["google"];

    public SocialAuthRequestValidator()
    {
        RuleFor(x => x.IdToken).NotEmpty().MaximumLength(4096);
        RuleFor(x => x.Provider)
            .NotEmpty()
            .Must(p => SupportedProviders.Contains(p))
            .WithMessage("Provider must be one of: google");
    }
}
