#!/bin/bash
SBATCH --account=aiuserapps  --partition=debug
SBATCH --time=4:00:00
SBATCH --job-name=bench_pglib
SBATCH --mail-user=harsh.gangwar@nrel.gov
SBATCH --mail-type=BEGIN,END,FAIL
SBATCH --output=Optim_log.%j.out  # %j will be replaced with the job ID

module load julia
module use /nopt/nrel/apps/cpu_stack/software/ipopt/modules/test
module load netlib-lapack
module -d avail ipopt
module load ipopt

./benchmark_ipopt.sh