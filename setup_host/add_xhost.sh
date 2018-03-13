#!/bin/bash

perl -pi -e 's/^lightdm:(.*)(\/bin\/false)$/lightdm:$1\/bin\/bash/' /etc/passwd
export DISPLAY=":0"
service lightdm start
# Critical to wait a bit: you can't run xhost too fast after x starts
sleep 5
#
# This xhost command is key to getting Lubuntu working properly with nvidia-driven GPU support.
#
su - lightdm -c "xhost +si:localuser:root"
perl -pi -e 's/^lightdm:(.*)(\/bin\/bash)$/lightdm:$1\/bin\/false/' /etc/passwd
