#!/bin/bash
#SBATCH --job-name=john_distributed_test
#SBATCH --output=/home/slurm/john_distributed_result_%j_%t.log
#SBATCH --error=/home/slurm/john_distributed_error_%j_%t.log
#SBATCH --nodes=3
#SBATCH --ntasks=3

# Create log files to satisfy Slurm's requirements
touch /home/slurm/john_distributed_result_%j_0.log
touch /home/slurm/john_distributed_result_%j_1.log
touch /home/slurm/john_distributed_result_%j_2.log
touch /home/slurm/john_distributed_error_%j_0.log
touch /home/slurm/john_distributed_error_%j_1.log
touch /home/slurm/john_distributed_error_%j_2.log

# Array of wordlist files
WORDLISTS=(/scratch/john/run/passwordlist_00 /scratch/john/run/passwordlist_01 /scratch/john/run/passwordlist_02)

# Loop through each wordlist and start a separate srun command
for i in "${!WORDLISTS[@]}"; do
    srun --exclusive -N1 -n1 /scratch/john/run/john --format=raw-sha256 --rules=Jumbo --fork=2 --wordlist="${WORDLISTS[$i]}" /home/slurm/john_hash.txt &
done

# Wait for all background processes to complete
wait

