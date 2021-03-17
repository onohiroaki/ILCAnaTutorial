bsub -o runmarlin.log -J runmarlin "(./runmarlin.sh > runmarlin.log 2>&1 )"
# -N is to notify by email when job exits.
