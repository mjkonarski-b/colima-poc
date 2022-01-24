# colima-poc
Docker container causing Colima network problems

The docker image install python and poetry and tries to install some python dependencies in a loop. The problem's symptoms is that after a while network connections
breaks with errors like `Failed to establish a new connection: [Errno 101] Network is unreachable'`. After this happens, the whole qemu machine can't access network.


```
brew install colima

# make sure a fresh qemu machine is created
colima stop
colima delete
colima start --cpu 4 --memory 8 --verbose
docker-compose up
```

After the problem occurs:
``` 
limactl shell colima
ping 8.8.8.8
```

Ping doesn't work. If you wait long enough it gets better. If you restart qemu machine it works fine (until the next time).