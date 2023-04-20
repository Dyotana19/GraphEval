#!/bin/bash

# Parse command line arguments
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <input.fasta> <read_length> <num_reads> <H> <output_fasta>" >&2
    exit 1
fi

input_fasta="$1"
read_length="$2"
num_reads="$3"
H="$4"
output_fasta="$5"

# Compute nbases
nbases=$((read_length * num_reads))


# Run the SeqRequester command
echo "${read_length} ${H}" > H
seqrequester simulate -genome "$input_fasta" -nbases "$nbases" -distribution H > $output_fasta

echo "Simulated reads written to $output_fasta"
