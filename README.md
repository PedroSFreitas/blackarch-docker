# BlackArch Unofficial Docker image

## -> Overview

This Dockerfile aims to create a "small", when possible, working BlackArch
environment.

Upon built you will have `base` and `base-devel` groups installed, as well as 
the BlackArch repository configured. This means you will have a full system as a
container, i.e. around 1.7GB of default packages.

note: you can change the mirror you want under:

* `/etc/pacman.d/blackarch-mirrorlist`

The image doesn't have any application installed, except from those present in
the groups mentioned above. This is because we don't want the default image too
big; as well as give you total control of what to be installed during building.
But we have shipped some useful configuration (radare2 and gdb, for instance).

## -> Before building

Before start the build, you can check `build.sh`. There you'll find three places
where you can tweak the image building process under Docker.

The first option is `packages_base`, even though we suggest not to change it,
you can change, add or remove any package.

The second option is to tweak `packages_security`. There you can tell at build
time what package should be installed on the image (container). Here is 
definitely the place to add, remove or change any application.

The third and last place is a function called `user_customize`. Here you can add
any system command to be ran at the environment during the boot process. This is
a great place to run configuration/settings command or to download (curl, wget)
any special configuration file or whatever you want. Feel free.
note: just keep in mind that the docker image will fail if a command return non
zero exit code.

## -> Building

First, git clone this repository or simply download and untar/extract it.
If you read the section above you know you can tweak the build process. If you
haven't, I strongly suggest you stop here and read the section above.

To build the image, run:
```
$ docker build --rm --force-rm --tag blackarch/base .
```

Of cource, you can name (`tag`) as whatever you please; feel free. However we'll
stick with `blackarch/base`.

Now to run the image, creating a container, run (attention):
```
$ docker run -it \
    --memory 512M \
    --hostname blackarch \
    --name blackarch \
    blackarch/base
```

ATTENTION:
If you are running this Docker image under a Arch Linux installation, you could
share pacman's cache folder to avoid unnecessary bandwidth. Just mount the cache
folder as volume (mount bind):

```
$ docker run -it \
    --memory 512M \
    --hostname blackarch \
    --name blackarch \
    --mount \
        type=bind,\
        source=/var/cache/pacman/pkg,\
        target=/var/cache/pacman/pkg \
    blackarch/base
```

After the container creation, you can just:

```
$ docker start blackarch -ai
```

## -> Todo

- [ ] reduce the base installation: we don't need much of the packages in there.

