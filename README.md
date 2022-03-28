moved future development to [my new repo](https://github.com/PixPMusic/nginx-rtmp-stunnel) for better compatability with RTMPS

I originally built this so I could have the RTMP module in my LetsEncrypt docker so I didn't have to nginx while I nginx'd, but turns out, mod-rtmp was being included in the upstream container.
This now just has ffmpeg and some other updated packages. The upstream is probably fine. I haven't tested RTMP on the linuxserver/letsencrypt container.
Don't expect this to be well maintained.

[linuxserver/letsencrypt](https://github.com/linuxserver/docker-letsencrypt) This is the nginx image I'm basing from  
[nginx-rtmp-module updated](https://github.com/sergey-dryabzhinsky/nginx-rtmp-module) this one has support for dynamic loading and is just generally newer code  
[original nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module) These guys deserve some love too.  
[arut/docker-nginx-rtmp](https://github.com/alfg/docker-nginx-rtmp) also a great source of help for my very basic docker skills.
