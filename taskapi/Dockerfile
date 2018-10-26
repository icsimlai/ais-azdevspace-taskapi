FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY ["aisazdevspace-taskapi.csproj", "."]
RUN dotnet restore "aisazdevspace-taskapi.csproj"
COPY . .
RUN dotnet build "aisazdevspace-taskapi.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "aisazdevspace-taskapi.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "aisazdevspace-taskapi.dll"]