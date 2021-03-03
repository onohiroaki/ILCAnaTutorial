# Setup cvmfs

A document to install CVMFS is available at 
```
https://cvmfs.readthedocs.io/en/stable/cpt-quickstart.html
```

Below, an example to install CVMFS for CentOS7 is described. 
An instruction for other OS is described in the above web page.

## Add cvmfs yum repository

As root, do 

```
yum install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm 
yum install -y cvmfs cvmfs-config-default

cvmfs-config setup
``` 

## Create `/etc/cvmfs/default.local` with following contents.
 
``` 
CVMFS_QUOTA_LIMIT='32140' 
CVMFS_CACHE_BASE='/var/lib/cvmfs' 
CVMFS_REPOSITORIES='ilc.desy.de' 
CVMFS_HTTP_PROXY=DIRECT 
```

## Create a desy config file `/etc/cvmfs/domain.d/desy.de.conf` with following contents.
 
``` 
CVMFS_SERVER_URL='http://grid-cvmfs-one.desy.de:8000/cvmfs/@fqrn@;http://cvmfs-stratum-one.cern.ch:8000/cvmfs/@fqrn@;http://cvmfs-egi.gridpp.rl.ac.uk:8000/cvmfs/@fqrn@' 
CVMFS_KEYS_DIR=/etc/cvmfs/keys 
```

## Copy the desy.de.pub key from the web:

``` 
cd /etc/cvmfs  
wget https://confluence.desy.de/download/attachments/159747860/desy.de.pub -O desy.de.pub
```
See https://confluence.desy.de/display/grid/CVMFS+repositories if this doesn't work

## Restart autofs

```
systemctl restart autofs

```
