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

### Symptoms

The image runs in an infinite loop. The problem usually occurs during the second or third run:

```
colima-poc-sample-1  | Creating virtualenv colima-poc-RipdXf2N-py3.8 in /root/.cache/pypoetry/virtualenvs
colima-poc-sample-1  | Installing dependencies from lock file
colima-poc-sample-1  |
colima-poc-sample-1  | Package operations: 45 installs, 0 updates, 0 removals
colima-poc-sample-1  |
colima-poc-sample-1  |   • Installing six (1.16.0)

...

colima-poc-sample-1  |   • Installing py (1.11.0)
colima-poc-sample-1  |
colima-poc-sample-1  |   ConnectionError
colima-poc-sample-1  |
colima-poc-sample-1  |   HTTPSConnectionPool(host='pypi.org', port=443): Max retries exceeded with url: /pypi/py/1.11.0/json (Caused by NewConnectionError('<urllib3.connection.HTTPSConnection object at 0xffff9d64e3d0>: Failed to establish a new connection: [Errno 101] Network is unreachable'))
colima-poc-sample-1  |
colima-poc-sample-1  |   at ~/.poetry/lib/poetry/_vendor/py3.8/requests/adapters.py:516 in send
colima-poc-sample-1  |       512│             if isinstance(e.reason, _SSLError):
colima-poc-sample-1  |       513│                 # This branch is for urllib3 v1.22 and later.
colima-poc-sample-1  |       514│                 raise SSLError(e, request=request)
colima-poc-sample-1  |       515│
colima-poc-sample-1  |     → 516│             raise ConnectionError(e, request=request)
colima-poc-sample-1  |       517│
colima-poc-sample-1  |       518│         except ClosedPoolError as e:
colima-poc-sample-1  |       519│             raise ConnectionError(e, request=request)
colima-poc-sample-1  |       520│
colima-poc-sample-1  |
colima-poc-sample-1  |   • Installing python-slugify (5.0.2)
colima-poc-sample-1  |   • Installing pytz (2021.3)
colima-poc-sample-1  |

```


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