# Contributing to acmetool docker image

## Update acmetool version and build docker image

```
# Clone repo
./update.sh

git commit -m 'Updated acmetool to latest version'

docker build -t 'cyon/acmetool:latest' -t 'cyon/acmetool:<version_number>' .
```

## Publish image to docker hub
```
docker push 'cyon/acmetool:latest'
docker push 'cyon/acmetool:<version_number>'
```
