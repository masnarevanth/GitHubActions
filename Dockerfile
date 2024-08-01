#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:8.0-preview AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0-preview AS build
WORKDIR /src
COPY ["MyConsoleApp.csproj", "."]
RUN dotnet restore "./MyConsoleApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "MyConsoleApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyConsoleApp.csproj" -c Release -o /app/publish
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyConsoleApp.dll"]
