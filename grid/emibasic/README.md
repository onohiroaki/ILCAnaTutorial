# Basic example to use EMI installed in KEK

Details will be found at [KEKCC EMI guide](https://kekcc.kek.jp/service/kekcc/html/EMIE382B7E382B9E38386E383A0.html#t862b6d5)( in Japanese )


## Setting environment

```
source setup-cvmfs-ui.sh 
voms-proxy-init --voms ilc -valid 144:00 -vomslife 144:00
```
`setup-cmfs-ui.sh` will be found in [../setup](`grid/setup`) directory.

Note that EMI environment is not compatible with ILCDIRAC.

## Simple job submission  

### Job submission
```
cd jobs
. jobsub.sh 
```

A file, `jobid.txt`, contains jobIDs submitted by this command.

### Check job status 

```
glite-ce-job-status -i [jobid-file]
```
[jobid-file] is `jobid.txt`

or 

```
glite-ce-job-status <jobID_1> <jobID_2> ... <jobID_N>
```

To display details of last submitted job
```
glite-ce-job-status -d `tail -1 jobid.txt` 
```

###  Get job output

```
glite-ce-job-output -i [jobid-file]
```
Job output is stored in a directory with a name delived from job id

### Cleans one or more jobs from CREAM based CEs

```
glite-ce-job-purge -i jobid.txt
```

## Submit a job to heavy queue

```
glite-ce-job-submit -r kek2-ce01.cc.kek.jp:8443/cream-lsf-gridilc_heavy -o jobid.txt -a test.jdl
```


## lcg-infosites command

`lcg-infosites` command is useful to get information about LCG grid.
Examples are as follows

```
lcg-infosites --vo ilc ce   # List of CE and queue available

lcg-infosites --vo ilc se   # List of available SE's
```

## lfc 

LFC is an old GRID file catalog system, which is not officially used by ILD.
But it is still operational by DESY and old files may be still accessible using LFC.
Note that the LFC could be out of service at ANY time.

### Access file catalog
```
lfc-ls /grid/ilc/user
```
Files under user directory will be displayed.

### Copy file
```
# Copy file from lfn_name to file_path
gfal-copy lfn_name file_path
where 
lfn_file : LFC file path, like lfn:/grid/ilc/user/....
file_path : Local file path, like file:///home/ilc/youname. 
```

SRM URI path, which does not depend on LFC, can be specified instead of LFC path
