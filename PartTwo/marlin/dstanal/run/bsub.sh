bsub -o rundst.log -q s -J rundst  "( ./rundst.sh > rundst.log 2>&1 )" 
