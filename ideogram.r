library(karyoploteR) 
library(rtracklayer) 
genome_file <- "C:/Users/dyota/Downloads/Homo_sapiens-GCA_009914755.4-2022_07-genes.gff3" 
cytobands_file <- "C:/Users/dyota/Downloads/output_CHM13_MCv2.txt" 




# Step 3: Import the gene annotations from the GFF3 file
gene_annotations <- import(genome_file)

# Step 4: Create the custom genome and cytobands objects 
custom.genome <- toGRanges(data.frame(chr = c("6"), start = c(28510120), end = c(33480577))) 
custom.cytobands <- toGRanges(cytobands_file) 

# Step 5: Create the karyoploteR plot 
kp <- plotKaryotype(genome = custom.genome, cytobands = custom.cytobands,plot.type=2,cex=1.6) 

# Step 6: Plot density along the genome using gene annotations 
kpPlotDensity(kp, gene_annotations, r0 = 0, r1 = 1.0,window.size = 0.5e6,col="#3388FF", border="#3388FF") # Step 7: Adjust the plot margins and sizes 
#kpPlotRegions(kp, data=gene_annotations)

kpAddBaseNumbers(kp, r0 = 0, r1 = 10, cex = 1, labels.font = 1) 


# Step 8: Add ending locations on the ideogram 

kpAxis(kp, side = "bottom", tck = -0.02, cex.axis = 1.2) 

# Display the plot 
print(kp)


