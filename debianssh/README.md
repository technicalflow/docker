# SSH access with public/private keys

This container can be used as an isolated environment accessed remotely to retrieve or drop files for archival. Volume-mounted storage can be provided as persistent storage.

## Configuration
  - 3MB Ram docker ssh image
  - *sshadmin* is default admin account
  - sudo is enabled without password authentication
  - Place public key (key.pub) in the container when image is built or volume-mount directory with public key in it.
  - Listens to default port 22, but you can use a different port by editing /etc/ssh/sshd_config.

## Run examples

Map to a non-default port.

```bash
$ docker run -d -p 2022:22 techfellow/debianssh
```

Volume-mount public SSH key:

```bash
$ docker run -d -p 2022:22 -v /home/user/.ssh:/home/sshadmin/.ssh techfellow/debianssh
```

Tested on 17.12.2022