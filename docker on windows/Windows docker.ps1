# Pull the Windows Server Core LTSC 2016 image from the Microsoft Container Registry
docker pull mcr.microsoft.com/windows/servercore:ltsc2016

# Run a new container using the Windows Nano Server 2022 image and open a command prompt inside it
docker run -it mcr.microsoft.com/windows/nanoserver:2022 cmd
