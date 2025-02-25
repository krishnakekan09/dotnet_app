# Use the official .NET image from Microsoft
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["dotnet-app/dotnet-app.csproj", "dotnet-app/"]
RUN dotnet restore "dotnet-app/dotnet-app.csproj"
COPY . .
WORKDIR "/src/dotnet-app"
RUN dotnet build "dotnet-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnet-app.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnet-app.dll"]
