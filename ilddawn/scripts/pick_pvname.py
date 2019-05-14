#!/usr/bin/env python
#
# Pickup PVName from PVName.list
#
import os
import glob

def pick_v1():
    pvnames = []
    for line in open("PVName.list"):
       (aname, dummy) = line.split()[1].rsplit('_',1)
       if "wafer" in aname: 
          continue
       namekeys = aname.split("_")
       if namekeys[0] not in pvnames:
          print namekeys[0]
          pvnames.append(namekeys[0])

    # for ent in pvnames:
    #    print ent

def pick_v2():
    pvnames = []
    for line in open("PVName.list"):
       (aname, dummy) = line.split()[1].rsplit('_',2)
       if "wafer" in aname: 
          continue
       namekeys = aname.split("_")
       if namekeys[0] not in pvnames:
          print namekeys[0]
          pvnames.append(namekeys[0])

    # for ent in pvnames:
    #    print ent


if __name__ == "__main__":

    pvnames = []
    for line in open("PVName.list"):
       spline=line.split()
       pvnsplit = spline[1].split("_")
       if len(pvnsplit) <= 2:
          aname = pvnsplit[0]
       else:
          aname = "_".join(pvnsplit[0:2])
          lastword = aname.split("_")[1]
          if "av" not in aname and unicode(lastword).isnumeric():
             aname = aname.split("_")[0]
          if "Ecal" in aname or "Hcal" in aname or "Yoke" in aname or "Lcal" in aname or "Cal" in aname: 
             aname = pvnsplit[0]

       # if "av" in line:
       #   print line
       #   print aname

       if aname not in pvnames:
          print aname
          pvnames.append(aname)

