# Contributing to acmetool docker image

# Update acmetool version and build docker image

```
# Clone repo
./update.sh

git commit -m 'Updated acmetool to latest version'

docker build -t 'cyon/acmetool:latest' 'cyon/acmetool:<version_number>' .
```
