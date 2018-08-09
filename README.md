# acmetool

Bundling [acmetool](https://hlandau.github.io/acme/).


![acmetool](https://raw.githubusercontent.com/cyon/docker-acmetool-libcloud/f42fa6930fd49544d66c4e56f38bda42c73a7a6c/img/acmetool-logo-black.png)

# How to use this image

### Prepare acmetool state folder

```console
mkdir -p /my/acme/conf
wget -O /my/acme/conf/responses https://raw.githubusercontent.com/hlandau/acme/master/_doc/response-file.yaml
# Edit /my/acme/conf/responses file according to your needs
```

### Define your desired domains and provider
```console
cat <<EOF > /my/acme/desired/my.example.com-desire
satisfy:
  names:
    - example.com       # The names you want on the certificate.
    - www.example.com

request:
  provider:               # ACME Directory URL. Normally set in conf/target only.
  ocsp-must-staple: true  # Request OCSP Must Staple. Use with care.
  challenge:
    webroot-paths:        # You can specify custom webroot paths.
      - /var/www
    http-ports:           # You can specify different ports for proxying.
      - 123               # Defaults to listening on localhost.
      - 456
      - 0.0.0.0:789       # Global listen.
    http-self-test: false # Defaults to true. If false, will not perform self-test
                          # but will assume challenge can be completed. Rarely needed.
    env:                  # Optionally set environment variables to be passed to hooks.
      FOO: BAR
  key:                    # What sort of key will be used for this certificate?
    type: rsa|ecdsa
    rsa-size: 2048
    ecdsa-curve: nistp256
    id: krzh2akn...       # If specified, the key ID to use to generate new certificates.
                          # If not specified, a new private key will always be generated.
                          # Useful for key pinning.

priority: 0
EOF

# Make sure you lower the file permission of this file 
# because it contains sensitive information.
```

### Get the desired certificates
```console
docker run --rm -v /my/acme:/var/lib/acme cyon/acmetool:latest

```

### Get the desired certificates and show debug output
```console
docker run --rm -v /my/acme:/var/lib/acme cyon/acmetool:latest -- --xlog.severity=debug

```

### Inspect certificates and keys
The live folder always contains all the certificates, chains and keys. A reissue of the certificate will update the certificate and chain files.

```console
$ tree /my/acme/live/my.example.com
> live/my.example.com
> ├── cert
> ├── chain
> ├── fullchain
> ├── privkey -> ../../keys/s4cy32o8kaucxkb37k9kajkq7atof8x0/privkey
> └── url
>
> 0 directories, 5 files

```

## Use a data volume container
If you want to share the certificates and keys between containers it's best to create a named Data Volume Container. The volume destination inside the container is '/var/lib/acme'.

### Create a named data volume container
```console
docker create --name acmetool cyon/acmetool:latest echo "Data-only container for acmetool hook"
```


### Copy your configurations and desired setting into the volume
```console
# Run once to create all the acmetool state folders
docker run --rm --volumes-from acmetool cyon/acmetool:latest

docker cp responses acmetool:/var/lib/acme/conf/
docker cp my.example.com-desire acmetool:/var/lib/acme/desired/
```

### Get the desired certificates
```console
docker run --rm --volumes-from acmetool cyon/acmetool:latest

```

### Use certificate from a nginx container
```console
docker run --volumes-from acmetool:ro --name nginx-with-acme-certs -d nginx
```
