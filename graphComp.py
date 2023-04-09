import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt


# Prompt user for number of files to read in
num_files = int(input("Enter the number of TSV files to read: "))

# Initialize list to store dataframes
dfs = []

# Loop through each file and read into a dataframe
for i in range(num_files):
    filename = input("Enter the filename of TSV file " + str(i+1) + ": ")
    df = pd.read_csv(filename, delimiter='\t')
    dfs.append(df)

# Create KDE plot
for i, df in enumerate(dfs):
    sns.kdeplot(data=df['cost'])

plt.legend(["Minigraph", "Minichain 1.1","Minichain 1.2"])
plt.title("Kernel density estimation of read alignments on diffrent tools")

# Save plot to file
plt.savefig('kde_plot.png')
print("Kernel density estimation plot is saved as kde_plot.png")
