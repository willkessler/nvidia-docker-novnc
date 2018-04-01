![Preview Image](https://cdn-images-1.medium.com/max/1600/1*wKNrdA3rqpHZU82DU4gVPA.gif)

### Building a GPU-enhanced Lubuntu Desktop with nvidia-docker2

To build on a plain vanilla Google Compute GPU host:

1. Spin up a GC GPU host on the google console.  Make sure it has at least one Tesla K80 GPU, and decent amount of VCPUs (e.g. 4, and enough disk space, at least 50Gb). Zone `us-east-1c` seems to be the best choice as of April 1, 2018.
1. Upload this repo and unpack it in `/root/build` or wherever you like as a temporary location.
1. Run `preinstall.sh`. This just runs `apt-get update` and puts in `screen` and `emacs` for getting started.
1. Run `build.sh`. This will build everything needed to start up a nvidia-docker2 container with Ubuntu 16.04 and Lubuntu desktop.

![SetupImage1](https://user-images.githubusercontent.com/176268/38177239-00283584-35b3-11e8-9c84-4f788120caca.png)
![Setupimage2](https://user-images.githubusercontent.com/176268/38177244-0b6b4d3c-35b3-11e8-8605-ed184afa59a6.png)

### Running the container

To run the container on this host, use `run.sh`. Note that NoVNC will
expect connections on port 40001. Then surf to your host on that port.

### Setting up network access

Thanks to @moorage for these tips on configuring network access.

https://github.com/willkessler/nvidia-docker-novnc/issues/2


### More info

For more links and reference, please see the Medium posting about this environment [here](https://engineering.udacity.com/creating-a-gpu-enhanced-virtual-desktop-for-udacity-497bdd91a505).
