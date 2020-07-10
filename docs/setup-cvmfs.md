# Setup cvmfs

CVMFS documentation is available at 
```
https://cernvm.cern.ch/portal/filesystem/quickstart
```

To Install, do following command as a root

## Add the cvmfs yum repository
 
```
yum install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm 
``` 
If this doesn't work for you, try following link.
Yum repositories for 64bit and 32bit Scientific Linux 5 and 6 and 64bit Scientific Linux 7 are available at
```
http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-release-latest.noarch.rpm
```

An apt repository for Ubuntu packages is available under 
```
http://cvmrepo.web.cern.ch/cvmrepo/apt
```
## install the packages
 
``` 
yum install cvmfs cvmfs-config-default 
``` 

## Config cmvfs
 
``` 
cvmfs_config setup 
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
wget http://grid.desy.de/etc/cvmfs/keys/desy.de.pub -O /etc/cvmfs/keys/desy.de.pub 
```

