#!/bin/bash
#SBATCH --job-name=test_john
#SBATCH --output=/home/slurm/john_result.log
#SBATCH --error=/home/slurm/john_error.log
#SBATCH --nodelist=node1

john --format=raw-SHA256 --wordlist=/opt/john/password.lst /home/slurm/john_hash.txt

