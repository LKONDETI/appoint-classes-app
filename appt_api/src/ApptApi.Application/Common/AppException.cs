namespace ApptApi.Application.Common;

public class AppException : Exception
{
    public string ErrorCode { get; }

    public AppException(string errorCode, string message) : base(message)
    {
        ErrorCode = errorCode;
    }
}

public class ConflictException : AppException
{
    public ConflictException(string errorCode, string message) : base(errorCode, message) { }
}

public class UnauthorizedException : AppException
{
    public UnauthorizedException(string errorCode, string message) : base(errorCode, message) { }
}

public class NotFoundException : AppException
{
    public NotFoundException(string errorCode, string message) : base(errorCode, message) { }
}
