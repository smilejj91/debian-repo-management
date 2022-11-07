# mirror-repo

### build with Dockerfile
```bash
$ docker build . --no-cache -t mirror-repo:{tag}
```

### using mirror.sh in docker 

```bash
$ docker cp mirror.sh {mirror-repo container}:/app/
$ ./mirror.sh {distribution}
```
