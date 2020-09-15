# ARC CE how to since KEKCC 2020


## Setting up GRID environment

```
source setup-ui-umd4.sh


voms-proxy-init --vomses ilc
```

Reference: [https://kekcc.kek.jp/service/kekcc/support/ja/08/](https://kekcc.kek.jp/service/kekcc/support/ja/08/)

## gfal-ls 

```
gfal-ls  srm://kek2-se01.cc.kek.jp:8444/srm/managerv2?SFN=//ilc

gfal-ls  srm://kek2-se01.cc.kek.jp:8444/srm/managerv2?SFN=/disk/ilc
```

## Submit job to arc ce

### Job description language, xRSL

[http://www.nordugrid.org/arc/arc6/users/xrsl.html](http://www.nordugrid.org/arc/arc6/users/xrsl.html)

### Files
[test.xrsl, an example of job description language](test.xrsl)  
[test.sh, an example of script to run at arc ce](test.sh) 

### Submit job to arc
```
arcsub -j jobs.xml -o jobid.txt -c https://kek2-ce01.cc.kek.jp/arex test.xrsl

または

arcsub --debug=DEBUG  -j jobs.xml -o jobid.txt -c https://kek2-ce01.cc.kek.jp/arex test.xrsl
```

### Job status
```
arcstat -j jobs.xml 

または

arcstat -a -j jobs.xml
```

### Kill job 
```
arckill -j jobs.xml <JobID>
```

### Get job output
```
arcget -j jobs.xml <JobID>
```

