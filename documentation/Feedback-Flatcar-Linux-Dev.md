# Feedback by a Flatcar Linux developer

> Jeremi:  
> So here goes: if you want to try the native nvidia way, I patched it up to make it work on Flatcar and tried to get NVIDIA to merge this but haven't had luck so far. Fetch this repo: <https://github.com/jepio/nvidia-driver-container>, then go into flatcar/ subdir and follow the instructions, you basically need the steps:
>
> ```bash
> docker run .... nvcr.io/.../container-toolkit
> systemctl restart docker.service
> DRIVER_VERSION=XXX # set one that supports the 5.15 kernel. I think 470+?
> docker build --build-arg DRIVER_VERSION=$DRIVER_VERSION ... # --build-arg is missing in the README
> docker run ... nvidia/nvidia-driver-flatcar:$DRIVER_VERSION init # skip the -d the first times to check that it works
> ```
>
> After this docker run --gpus all should work
