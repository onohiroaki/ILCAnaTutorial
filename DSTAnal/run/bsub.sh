# bsub -o rundst.log -q s -J rundst  "( ./rundst.sh > rundst.log 2>&1 )" 

bsub -o rundst_many.log  -J rundst_many "( ./rundst-many.sh > rundst_many.log 2>&1 )"
