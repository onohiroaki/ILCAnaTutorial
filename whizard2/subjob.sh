
mkdir -p jobs

while read a b c; do 
   ( 
      cd jobs
      mkdir -p ${b}
      cd ${b}
      ln -s ../../run_whizard.sh .
      bsub -o run_whizard.log -q s -J ${a} "( ./run_whizard.sh ${a} ${b} ${c} > run_whizard.log )"
    )
done << EOF
E250.P4f_ww_h.eL.pR E250-SetA.P4f_ww_h.Gwhizard-2_7_0.eL.pR.I999998.001 999998
EOF
# E250.Pe2e2h.circes2  E250-SetA.Pe2e2h.Gwhizard-2_7_0.eL.pR.I999999.001 999999
