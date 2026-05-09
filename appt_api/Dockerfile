# ── Build stage ─────────────────────────────────────────────────────────────
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy solution and project files first for layer-cached restore
COPY appt_api.sln ./
COPY src/ApptApi.Domain/ApptApi.Domain.csproj             src/ApptApi.Domain/
COPY src/ApptApi.Application/ApptApi.Application.csproj   src/ApptApi.Application/
COPY src/ApptApi.Infrastructure/ApptApi.Infrastructure.csproj src/ApptApi.Infrastructure/
COPY src/ApptApi.API/ApptApi.API.csproj                   src/ApptApi.API/
COPY tests/ApptApi.UnitTests/ApptApi.UnitTests.csproj     tests/ApptApi.UnitTests/
COPY tests/ApptApi.IntegrationTests/ApptApi.IntegrationTests.csproj tests/ApptApi.IntegrationTests/

RUN dotnet restore

# Copy all source and publish
COPY . .
RUN dotnet publish src/ApptApi.API/ApptApi.API.csproj \
    -c Release -o /app/publish --no-restore

# ── Runtime stage ────────────────────────────────────────────────────────────
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 8080

ENTRYPOINT ["dotnet", "ApptApi.API.dll"]
