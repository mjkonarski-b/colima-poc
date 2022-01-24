# colima-poc
Docker container causing Colima network problems

### The problem

The docker image install python and poetry and tries to install some python dependencies in a loop. The symptoms are that after a while network connections
breaks with errors like `Failed to establish a new connection: [Errno 101] Network is unreachable'`. After this happens, the whole qemu machine can't access network.

### Steps to reproduce

```
brew install colima

# make sure a fresh qemu machine is created
colima stop
colima delete
colima start --cpu 4 --memory 8 --verbose

# build and run docker container
docker-compose up
```

After the problem occurs:
``` 
limactl shell colima
ping 8.8.8.8
```

Ping doesn't work. If you wait long enough it gets better. If you restart qemu machine it works fine (until the next time).


### Versions

```
$ colima version
colima version 0.3.2
git commit: 272db4732b90390232ed9bdba955877f46a50552

runtime: docker
arch: aarch64
client: v20.10.11
server: v20.10.11


$ limactl --version
limactl version 0.8.1


$ qemu-img --version
qemu-img version 6.2.0
Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers

```