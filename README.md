### Building a GPU-enhanced Lubuntu Desktop with nvidia-docker2

To build on a plain vanilla Google Compute GPU host:

1. Spin up a GC GPU host on the google console.  Make sure it has at least one Tesla K80 GPU, and decent amount of VCPUs.
1. Upload this repo and unpack it in `/root/build` or wherever you like as a temporary location.
1. Run `preinstall.sh`. This just runs `apt-get update` and puts in `screen` and `emacs` for getting started.
1. Run `build.sh`. This will build everything needed to start up a nvidia-docker2 container with Ubuntu 16.04 and Lubuntu desktop.

### Running the container

To run the container on this host, use `run.sh`. Note that NoVNC will
expect connections on port 40001. Then surf to your host on that port.

### More info

For more links and reference, please see the Medium posting about this environment here.
