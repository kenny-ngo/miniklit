## MINIKLIT

Miniklit is based on the LAMP ( an archetypal model of web service solution stacks ). It uses latest technology to provide faster service with reliability. The Miniklit consists 4 critical components:

- TinyCore ( tinycorelinux.net )
- Nginx ( nginx.org )
- PHP7-FPM ( php.net )
- MariaDB ( mariadb.org )

At the moment, it runs as a VM and depends on VirtualBox and Packer. Its ultimate goal is convert to machine images that can distribute to Cloud Providers such Amazon Web Services (AWS), Google, Microsoft and Rackspace.

## REQUIREMENTS

### Hardware

- Hypervisor ( > 2ghz )
- Memory ( > 8 gb )
- Storage ( > 40 gb )

### Software
- Windows / Linux / OSX
- VirtualBox ( virtualbox.org )
- Packer ( packer.io )
- GIT ( desktop.github.com ) * Optional
- SSH client


## INSTALLATION
> WARNING: large filesize  ( ~ 460mb )

### Windows
- You need to install cygwin or putty ( whichever you feel comfortable ). I personally use cygwin
- Install VirtualBox
- If you use GIT ( git clone https://github.com/kenny-ngo/miniklit.git )
- If you don't use GIT, you can download ( https://github.com/kenny-ngo/miniklit/archive/master.zip )

> Watch: https://www.youtube.com/watch?v=G95NSGW_Sg4


### Linux / OSX
- If you use GIT ( git clone https://github.com/kenny-ngo/miniklit.git )
- If you don't use GIT, you can download ( https://github.com/kenny-ngo/miniklit/archive/master.zip )

> Watch: https://www.youtube.com/watch?v=G95NSGW_Sg4

### Other Video Clips
- PHP7 Compilation on TinyCore7 x64 ( https://www.youtube.com/watch?v=xihhhqe3N5k )
- Building TinyCore 7.0 Container using Packer ( https://www.youtube.com/watch?v=9AEMpJJLiu0 )

## LICENSE
The MIT License (MIT)
