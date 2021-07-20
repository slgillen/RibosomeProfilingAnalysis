# scripts for ribosome profiling analysis 

#input file

gencode_v28_proteincoding_mostabundanttranscriptHEK293.fa.gz : the most abundant transcript for each gene was used for RPF alignments as determined using the total RNA seq data -> this is the file for those used in the downstream analysis

#Scripts

TotalRNA_alignments.sh - processing of fastq files for Total RNA seq data
RPF_smallRNA_alignments.sh - processing of fastq files for ribosome protected fragments
countingScript.py - python script used in RPF_smallRNA_alignment.sh for positional RPF counting - output is each mRNA sequence with the number of RPF read starts aligning to each position of the mRNA
countingFunctions.py - python module for RPF counting

RPFcountingforQCchecks.sh - runs the python counting scripts for each read length individually to provide input files for downstream frame and P-site offset analysis per read length

RibosomeProfiling_QC.R - 

