# Build stage using .NET 8 SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /app

# Copy files and publish release build
COPY . ./
RUN dotnet publish -c Release -o out

# Runtime stage using lightweight .NET 8 Alpine runtime
FROM mcr.microsoft.com/dotnet/runtime:8.0-alpine AS runtime
WORKDIR /app

# Copy published output from build stage
COPY --from=build /app/out ./

# Run container as non-root user
USER $APP_UID

# Start application
ENTRYPOINT ["dotnet", "ipcheck.dll"]