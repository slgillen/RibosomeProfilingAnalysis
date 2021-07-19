#!/bin/bash

#workflow for total RNA alignment with use of most abundant transcript per gene


inputdir='/inputfastqdirectory'
datadir='/processeddatadirectory'

inputfiles="Total_con1,Total_con2, Total_con3"

#initial fastqc checks
fastqcdir=$datadir/initial_fastqc
mkdir $fastqcdir

for s in ${inputfiles//,/ }
do	
  fastqc $datadir/${s}.fastq.gz --extract --outdir=$fastqcdir &
done
wait

for s in ${inputfiles//,/ }
do
  gunzip $datadir/${s}.fastq.gz
done
wait


#remove adapters, quality trimming
for s in ${inputfiles//,/ }
do
	cutadapt --nextseq-trim=20 -m 30 -a GGGGGGGG -o $datadir/${s}.fastq.gz $datadir/${s}_cutadapt.fq & 
done
wait

#deduplicate based on 12nt UMI at start of read
dedupdir=$datadir/dedup
mkdir $dedupdir

for s in ${inputfiles//,/ }
do
  cd-hit-dup -i $datadir/${s}_cutadapt.fq -o $dedupdir/${s}_dedup.fq -e 0
done
wait

#check the reads remaining
fastqcdir=$datadir/fastqc_afterdeduplication
mkdir $fastqcdir

for s in ${inputfiles//,/ }
do	
  fastqc $dedupdir/${s}_dedup.fq --extract --outdir=$fastqcdir &
done
wait

#remove UMI before alignment
for s in ${inputfiles//,/ }
do
	cutadapt -u 12 -o $trim2dir/${barcode}_UMIremoved.fq.gz $dedupdir/${barcode}_dedup.fq & 
done
wait

#alignment
annotation=$inputdir/gencode.v28.annotation.mostabundantTranscript.gtf
genome=$inputdir/GRCh38.primary_assembly.genome.fa

aligndir=$aligndir/alignments
mkdir $aligndir

for s in ${inputfiles//,/ }
do
    STAR --readFilesIn $rRNAdir/non_rRNA_${s}.fq --runThreadN 28 --genomeDir $inputdir --outFilterMultimapNmax 5 --outFilterMismatchNmax 2 --outSAMprimaryFlag AllBestScore --alignEndsType EndToEnd --outSAMtype BAM Unsorted --outSAMunmapped Within KeepPairs --sjdbGTFfile ${annotation} --outFileNamePrefix $aligndir/${s} 
done
wait

#sort bam
for s in ${inputfiles//,/ }
do
  samtools sort $aligndir/${s}Aligned.out.bam -o $aligndir/sorted_${s}_aligned.bam &
done
wait

#index bam
for s in ${inputfiles//,/ }
do
  samtools index $aligndir/sorted_${s}_aligned.bam $aligndir/sorted_${s}_aligned.bai & 
done
wait


#read counts
outputdir=$datadir/counts
mkdir $outputdir

for s in ${inputfiles//,/ };do
    featureCounts -a $annotation -s 1 -o $countsdir/fcounts_${s}.txt $aligndir/${s}_STARAligned_sorted.bam &
done
wait

#format output table
for s in ${inputfiles//,/ };do
    cut -f1,7-8 $countsdir/fcounts_${s}.txt > $countsdir/fcounts_${s}_matrix.txt
done
wait



