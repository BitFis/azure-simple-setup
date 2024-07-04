@echo off
cd %~dp0\..\
docker build . -f .\etc\docker\Dockerfile -t app
docker run --entrypoint sh --rm -it app