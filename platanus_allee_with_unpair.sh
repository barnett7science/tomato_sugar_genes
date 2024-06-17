#!/bin/bash

#BSUB -J platanus_al
#BSUB -n 1
#BSUB -R rusage[mem=17000]
#BSUB -R span[hosts=1]
#BSUB -q short
#BSUB -W 4:00

# bash script for running platanus_allee on paired trimmed reads found in
# the /reads/trim  directory
# written by Jake Barnett Nov. 2021

# this script is meant to be run inside the /assembled_contigs directory

set -o errexit

module load platanus_allee/2.0.2

# create array of accession names
declare -a arr=(
'SCR07_20211015'
'SCR08_20211015'
'SCR09_20210929'
'SL_AC_20210515'
'SL_GD_20210515'
'SL_SK_20210515'
'SPV04_20210318'
)

### Make sure the options in the run_details variable match the ones in the platanus_allee line below
run_details="plat_al_trim_PU_default_20211130"

echo "Run details are $run_details"
mkdir "$run_details"

for i in "${arr[@]}"; do
	echo "Starting with $i"
	platanus_allee assemble -o "$i" -f ../reads/trim/"$i"_trim_1P.fastq ../reads/trim/"$i"_trim_2P.fastq 2>"$i""$run_details"_assemble.log
	platanus_allee phase -o "$i" -c "$i"_contig.fa "$i"_junctionKmer.fa -IP1 ../reads/trim/"$i"_trim_1P.fastq ../reads/trim/"$i"_trim_2P.fastq 2>"$i""$run_details"_phase.log 
	platanus_allee consensus -o "$i" -c "$i"_primaryBubble.fa "$i"_nonBubbleHomoCandidate.fa -IP1 ../reads/trim/"$i"_trim_1P.fastq ../reads/trim/"$i"_trim_2P.fastq 2>"$i""$run_details"_consensus.log
	
	mv "$i"* ./"$run_details"
	
	echo "Finished with $i"
done


