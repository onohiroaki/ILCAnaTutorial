bsub -o runoverlay.log -J runoverlay "(./runoverlay.sh > runoverlay.log 2>&1 )"
# -N is to notify by email when job exits.
