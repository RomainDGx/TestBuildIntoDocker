# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src

COPY . .

RUN --mount=type=cache,id=nuget,target=/root/.nuget/packages \
    dotnet publish TestBuildIntoDocker.csproj --use-current-runtime -o /app /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/runtime:8.0-alpine
WORKDIR /app

COPY --from=build /app .

USER $APP_UID

ENTRYPOINT ["dotnet", "TestBuildIntoDocker.dll"]
