# scripts for ribosome profiling analysis 

#useful input files

#the most abundant transcript for each gene was used for RPF alignments as determined using the total RNA seq data -> these are the files for those used in the downstream analysis
mostabundant_transcriptpergene.gtf
mostabundant_transcriptpergene.fa

#Scripts

TotalRNA_alignments.sh - processing of fastq files for Total RNA seq data

RPF_smallRNA_alignments.sh - processing of fastq files for ribosome protected fragments
X.py - python file for getting RPF start position along transcripts
RPF_functions.py - python functions for RPF counting

determine_read_offsets.sh - script for generating R input tables to get read offset plots
frame_and_offset_plots.R - generate data for reads of each length in each frame and plot reads around AUG to see P-site offset required

