# Use the .NET runtime as a base image
FROM mcr.microsoft.com/dotnet/runtime:8.0-preview AS base
WORKDIR /app

# Use the .NET SDK to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0-preview AS build
WORKDIR /src

# Copy the .csproj file and restore dependencies
COPY ["MyConsoleApp.csproj", "."]
RUN dotnet restore "./MyConsoleApp.csproj"

# Copy the remaining source code and build the application
COPY . .
WORKDIR "/src"
RUN ls -la  # List the contents to debug
RUN dotnet build "MyConsoleApp.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "MyConsoleApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Use the runtime image to run the application
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyConsoleApp.dll"]
