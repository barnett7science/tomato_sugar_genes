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
'SA_05_20210728'
'SA_09_20211014'
'SA_18_20210728'
'SC_19_20210515'
'SC_22_20210515'
'SC_31_20210515'
'SCH02_20211015'
'SCH06_20210929'
'SCH08_20211015'
'SCM01_20211014'
'SCM03_20210929'
'SCM11_20210728'
'SCR07_20211015'
'SCR08_20211015'
'SCR09_20210929'
'SG_15_20210515'
'SG_23_20210515'
'SG_30_20210515'
'SH_01_20210728'
'SH_02_20210728'
'SH_05_20210728'
'SHY01_20210929'
'SHY02_20211014'
'SHY03_20211015'
'SL_AC_20210515'
'SLC10_20210515'
'SLC10_20211014'
'SLCB5_20210318'
'SLCB5_20210515'
'SLCB8_20210515'
'SL_GD_20210515'
'SL_SK_20210515'
'SN_02_20210929'
'SN_06_20211014'
'SN_08_20211014'
'SPE16_20210929'
'SPE20_20210318'
'SPE21_20211014'
'SPM01_20210515'
'SPMB5_20211014'
'SPMB6_20210515'
'SPV02_20211015'
'SPV04_20210318'
'SPV09_20210728'
)

### Make sure the options in the run_details variable match the ones in the platanus_allee line below
run_details="plat_al_trim_P_default_20211118"

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


