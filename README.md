## Docker container for Game and Watch and RPi

This repository will help you to build Docker image & container ready-to-use with Game and Watch under Rapsberry Pi.
This will prevent you starting from scratch, facing building issues and save lot of time.


# Warnings
If your testing environment run under Raspberry Pi 3, I highly recommend you 2 tips:
- Increase Swap memory to its max 2048. Refer to this [Cloud-oriented Life How-to article](https://cloudolife.com/2021/01/01/Raspberry-Pi/Resizing-or-disable-Swap-Size/) to help you.
- Decrease GPU mem to its lowest capacity to 16Mb by running below shell command. Go to "Performance Options" Menu, then "GPU memory" submenu.
> $ sudo raspi-config
- 
