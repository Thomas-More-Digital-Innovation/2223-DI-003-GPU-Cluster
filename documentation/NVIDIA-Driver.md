# NVIDIA driver

Workstation node:  
`K8S-9C1KZG2.cluster.internal`

Driver version:  
`510.47.03`

Container toolkit image:  
`nvcr.io/nvidia/k8s/container-toolkit:v1.11.0-ubuntu20.04`

```bash
# Load kernel modules required for NVIDIA drivers.
sudo modprobe -a loop i2c_core ipmi_msghandler \
    && echo -e "loop\ni2c_core\nipmi_msghandler" | sudo tee /etc/modules-load.d/driver.conf

# Load the NVIDIA container toolkit and let it change the host Docker daemon.json file.
docker run --rm --privileged \
     -v "/etc/docker:/etc/docker" \
     -v "/run/nvidia:/run/nvidia" \
     -v "/run/docker.sock:/run/docker.sock" \
     -v "/opt/nvidia-runtime:/opt/nvidia-runtime" \
     -e "RUNTIME=docker" \
     -e "RUNTIME_ARGS=--socket /run/docker.sock" \
     -e "DOCKER_SOCKET=/run/docker.sock" \
     nvcr.io/nvidia/k8s/container-toolkit:v1.11.0-ubuntu20.04 \
     "/opt/nvidia-runtime"

# Restart Docker and check if the NVIDIA runtime has registered.
sudo systemctl restart docker
docker info | grep -i nvidia

# Set the driver version. For kernel 5.15, this version works well.
DRIVER_VERSION=510.47.03

# Build the NVIDIA driver kernel modules on the host.
docker run -d --privileged --pid=host \
     --tmpfs /tmp \
     -v /run/nvidia:/run/nvidia:shared \
     -v /tmp/nvidia:/var/log \
     ghcr.io/jepio/nvidia-driver-container:${DRIVER_VERSION}-flatcar update

# Check if the kernel modules are loaded.
lsmod | grep -i nvidia

# Run the nvidia-smi command inside of a CUDA enabled container to check if the GPUs are recognized.
docker run --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 nvcr.io/nvidia/cuda:11.6.1-base-ubuntu20.04 nvidia-smi
```
