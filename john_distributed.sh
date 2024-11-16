#!/bin/bash
#SBATCH --job-name=john_distributed_test
#SBATCH --output=/home/slurm/john_distributed_error.log
#SBATCH --error=/home/slurm/john_distributed_result.log
#SBATCH --nodes=3
#SBATCH --ntasks=3


WORDLISTS=(/scratch/john/run/passwordlist_00 /scratch/john/run/passwordlist_01 /scratch/john/run/passwordlist_02)

for i in "${!WORDLISTS[@]}"; do
    srun --exclusive -N1 -n1 /scratch/john/run/john --format=raw-sha256 --rules=Jumbo --fork=2 --wordlist="${WORDLISTS[$i]}" /home/slurm/john_hash.txt &
done

wait

