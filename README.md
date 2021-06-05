# ltib-ub14
Ubuntu 14 LTIB image

# Xterm via WSL2 and docker container

Refer to https://wiki.ubuntu.com/WSL#Running_Graphical_Applications

From the WSL2 VM:

```
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=1
```

Launch container

```
docker run --rm -it -v $PWD:/home/workspace -v ltib-opt:/opt -e DISPLAY=$DISPLAY ltib-ub14 xterm
```

# i.MX25 PDK LTIB notes

Requisites
* L2.6.31_09.12.00_SDK_source.tar.gz on the installation media
* Oneiric patch: 
wget 'https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/imx-processors/9195/1/519-oneiricltibpatch.tgz'

* pkgs.tar.gz or use the pkgs found in the SDK


Untar the SDK in a temporary directory. The SDK contains a pkgs directory and ltib.tar.gz. Can use a recursive copy of the pkgs directory or untar if using pkgs.tar.gz

cd to where you want to install ltib

```
tar xzf ltib.tar.gz
tar -C ltib -xzf pkgs.tar.gz
chmod 644 ltib/pkgs/*
chmod 755 ltib/pkgs
wget 'https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/imx-processors/9195/1/519-oneiricltibpatch.tgz'
tar xzf 519-oneiricltibpatch.tgz
cd oneiricltib-ltib-patch
./install-patches.sh
cd ..
cd ltib
```

Need to patch bin/Libutils.pm see https://community.nxp.com/t5/i-MX-Processors-Knowledge-Base/Ubuntu-12-04-64-bit-Precise-Pangolin-Host-Setup-for-Building-i/ta-p/1115728
or you can search for zlib and glibc-devel and comment out the check in ./ltib.

Can then run ltib etc.

```
./ltib
./ltib -m config
./ltib --batch
```





