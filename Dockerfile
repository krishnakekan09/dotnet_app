# Use the official .NET 9 image from Microsoft
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
# Update the COPY statement to reflect the correct file location
COPY ["dotnet-app.csproj", "./"]  # Copy from the root to the current directory in the container
RUN dotnet restore "dotnet-app.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "dotnet-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnet-app.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnet-app.dll"]
