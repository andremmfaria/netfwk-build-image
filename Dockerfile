FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019 as builder

FROM andremmfaria/windows-dind-build-image:latest
LABEL MAINTAINER="Andre Faria <andremarcalfaria@gmail.com>"

# Install nuget
RUN powershell -Command \
    choco install -y webdeploy dotnetfx ; \
    New-Item -Path \"${Env:ProgramFiles}\NuGet\" -ItemType Directory ; \
    New-Item -Path \"${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\BuildTools\" -ItemType Directory ; \
    New-Item -Path \"${Env:ProgramFiles(x86)}\Reference Assemblies\Microsoft\Framework\.NETFramework\" -ItemType Directory

# Copy visual studio build tools from builder
COPY --from=builder ["C:/Program Files/NuGet", "C:/Program Files/NuGet"]
COPY --from=builder ["C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools", "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools"]
COPY --from=builder ["C:/Program Files (x86)/Reference Assemblies/Microsoft/Framework/.NETFramework", "C:/Program Files (x86)/Reference Assemblies/Microsoft/Framework/.NETFramework"]

# Set env vars
RUN powershell -Command \
    setx /M PATH $(\"${env:PATH};${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin;${Env:ProgramFiles}\NuGet;\")
