#!/bin/bash
#SBATCH --qos=regular
#SBATCH --nodes=1
#SBATCH --time=12:00:00
#SBATCH --constraint=cpu
#SBATCH --output=BATCH_OUTPUT_ALIGNMENT
#SBATCH --error=BATCH_OUTPUT_ALIGNMENT
#SBATCH --ntasks=1

EXE=src/astarix/release/astarix

# Check that two arguments were provided
if [ $# -ne 4 ]; then
  echo "Usage: $0 <graph.gfa> <reads.fasta> <graphname> <threadnum>"
  exit 1
fi

# Assign the arguments to variables
NC_GRAPH=Graphs/$1
READS=Reads/$2
TOOLNAME=$3
NUM_THREADS=$4

#make the graph astarix compatible
convertGFAToFwdStand='src/astarix/release/convertGFAToFwdStand'
$convertGFAToFwdStand $NC_GRAPH Graph_transformed.gfa
GRAPH=Graph_transformed.gfa


#path for storing the alignment result
OUTPUT=output/${TOOLNAME}_result

source ~/.bashrc
conda activate base
kill -9 $(pidof astarix)

# Set the number of threads
#NUM_THREADS=2

n=10

#split the reads based og the NUM_THREADS specified
seqkit split -p $NUM_THREADS $READS --by-part-prefix Read1_

threads=( $(seq 1 ${NUM_THREADS}))
for thread in "${threads[@]}"; do
        if [ ${thread} -lt $n ]
        then
            echo "Thread ${thread} is working on Read1_00${thread}"
            awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' ${READS}.split/Read1_00${thread}.fasta |  sed 1,1d - > temp_${thread} && mv temp_${thread} ${READS}.split/Read1_00${thread}.fasta
            $EXE align-optimal -D 14 -a astar-seeds -t 1 -v 0 -G 1 -q ${READS}.split/Read1_00${thread}.fasta -g $GRAPH -o ${OUTPUT}/OUT_${thread} --fixed_trie_depth 1 --seeds_len 5 > log_read1_${thread}.txt &
        else
            echo "Thread ${thread} is working on Read1_${thread}"
            awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' ${READS}.split/Read1_0${thread}.fasta |  sed 1,1d - > temp_${thread} && mv temp_${thread} ${READS}.split/Read1_0${thread}.fasta
            $EXE align-optimal -D 14 -a astar-seeds -t 1 -v 0 -G 1 -q ${READS}.split/Read1_0${thread}.fasta -g $GRAPH -o ${OUTPUT}/OUT_${thread} --fixed_trie_depth 1 --seeds_len 5 > log_read1_${thread}.txt &
        fi
done


wait $(pidof astarix)
echo "Deleting Reads ..."
rm -f Read1_*
rm -f log_read1_*
echo "Deleted Reads ..."
rm -r $GRAPH
echo "Deleted the converted graph.."
echo "Sequence to graph alignment done...output present in output/${TOOLNAME}_result folder!"
