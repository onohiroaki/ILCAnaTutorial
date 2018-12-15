# Setup cvmfs

Do following command as a root

## Add the cvmfs yum repository
'''
yum install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
'''

## install the packages
'''
yum install cvmfs cvmfs-config-default
'''

## Config cmvfs
'''
cvmfs_config setup
'''

## Create '/etc/cvmfs/default.local' with following contents.
'''
CVMFS_QUOTA_LIMIT='32140'
CVMFS_CACHE_BASE='/var/lib/cvmfs'
CVMFS_REPOSITORIES='ilc.desy.de'
CVMFS_HTTP_PROXY=DIRECT
'''

## Create a desy config file '/etc/cvmfs/domain.d/desy.de.conf' with following contents.
'''
CVMFS_SERVER_URL='http://grid-cvmfs-one.desy.de:8000/cvmfs/@fqrn@;http://cvmfs-stratum-one.cern.ch:8000/cvmfs/@fqrn@;http://cvmfs-egi.gridpp.rl.ac.uk:8000/cvmfs/@fqrn@'
CVMFS_KEYS_DIR=/etc/cvmfs/keys 
'''

## Copy the desy.de.pub key from the web:
''
cd /etc/cvmfs 
wget http://grid.desy.de/etc/cvmfs/keys/desy.de.pub -O /etc/cvmfs/keys/desy.de.pub
'''

