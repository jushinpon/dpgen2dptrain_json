#!/bin/sh
#sed_anchor01
#SBATCH --output=dptrain.out
#SBATCH --job-name=dp
#SBATCH --partition=debug   


source activate deepmd-cpu

threads=`lscpu|grep "^CPU(s):" | sed 's/^CPU(s): *//g'`
export OMP_NUM_THREADS=$threads
export KMP_AFFINITY=granularity=fine,compact,1,0
export KMP_BLOCKTIME=0
export KMP_SETTINGS=TRUE

dp train output.json
#sed_anchor03
dp freeze -o graph.pb
cp lcurve.out lcurve_ori.out
##sed_anchor04
dp compress -i graph.pb -o graph-compress.pb
##sed_anchor05
dp train output.json --init-frz-model graph-compress.pb
#
echo "Done" > train_done.txt
