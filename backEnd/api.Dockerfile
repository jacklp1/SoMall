#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["src/TT.SoMall.HttpApi.Host/TT.SoMall.HttpApi.Host.csproj", "src/TT.SoMall.HttpApi.Host/"]
COPY ["src/TT.SoMall.Application/TT.SoMall.Application.csproj", "src/TT.SoMall.Application/"]
COPY ["modules/shop-management/src/TT.Abp.ShopManagement.csproj", "modules/shop-management/src/"]
COPY ["src/TT.SoMall.Application.Contracts/TT.SoMall.Application.Contracts.csproj", "src/TT.SoMall.Application.Contracts/"]
COPY ["src/TT.SoMall.Domain.Shared/TT.SoMall.Domain.Shared.csproj", "src/TT.SoMall.Domain.Shared/"]
COPY ["src/TT.SoMall.Domain/TT.SoMall.Domain.csproj", "src/TT.SoMall.Domain/"]
COPY ["src/TT.SoMall.EntityFrameworkCore.DbMigrations/TT.SoMall.EntityFrameworkCore.DbMigrations.csproj", "src/TT.SoMall.EntityFrameworkCore.DbMigrations/"]
COPY ["modules/TT.Abp.VisitorManagement/TT.Abp.VisitorManagement.csproj", "modules/TT.Abp.VisitorManagement/"]
COPY ["modules/TT.Core/TT.Core.csproj", "modules/TT.Core/"]
COPY ["http_modules/TT.HttpClient.Weixin/TT.HttpClient.Weixin.csproj", "http_modules/TT.HttpClient.Weixin/"]
COPY ["src/TT.SoMall.EntityFrameworkCore/TT.SoMall.EntityFrameworkCore.csproj", "src/TT.SoMall.EntityFrameworkCore/"]
COPY ["modules/TT.Abp.WeixinManagement/TT.Abp.WeixinManagement.csproj", "modules/TT.Abp.WeixinManagement/"]
COPY ["src/TT.SoMall.IdentityServer/TT.SoMall.IdentityServer.csproj", "src/TT.SoMall.IdentityServer/"]
COPY ["src/TT.SoMall.HttpApi/TT.SoMall.HttpApi.csproj", "src/TT.SoMall.HttpApi/"]
COPY ["modules/TT.Abp.OssManagement/TT.Abp.OssManagement.csproj", "modules/TT.Abp.OssManagement/"]
RUN dotnet restore "src/TT.SoMall.HttpApi.Host/TT.SoMall.HttpApi.Host.csproj"
COPY . .
WORKDIR "/src/src/TT.SoMall.HttpApi.Host"
RUN dotnet build "TT.SoMall.HttpApi.Host.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TT.SoMall.HttpApi.Host.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TT.SoMall.HttpApi.Host.dll"]