Honestly, I'm just some asshole running like 5 instances of nginx on my unRAID box and got sick of it.
Don't expect this to be well maintained.

[linuxserver/letsencrypt](https://github.com/linuxserver/docker-letsencrypt) This is the nginx image I'm basing from
[nginx-rtmp-module updated](https://github.com/sergey-dryabzhinsky/nginx-rtmp-module) this one has support for dynamic loading and is just generally newer code
[original nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module) These guys deserve some love too.
[arut/docker-nginx-rtmp](https://github.com/alfg/docker-nginx-rtmp) also a great source of help for my very basic docker skills.

I still don't know why my DockerFile ARGS aren't working, so that's fun.
I probably could have just done a `FROM linuxserver/letsencrypt` and added the files I built, but I also wanted to replace the default nginx.conf
I'll probably simplify the build of this docker image over time, being honest. Right now, though, I just know it works.

[Docker Hub](https://hub.docker.com/r/pixelperfect/nginx-letsencrypt-ffmpeg)
