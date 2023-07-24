import pandas as pd
import numpy as np

CSV_PATH = "/storage/store/kevin/local_files/exp1/results/SCCS_results.csv"

raw_data = pd.read_csv(CSV_PATH)
num_folds = 5
data = [[] for _ in range(num_folds)]
num_points = len(raw_data) // num_folds
for i in range(num_folds):
    for j in range(num_points):
        data[i].append(raw_data.iloc[i * (num_points) + j].tolist())
scores = []
paths = []
# Access data for each fold
for fold_idx, fold_data in enumerate(data):
    for row in fold_data:
        paths.append(row[0])
        scores.append(row[1])
means = []
# for the number of datapoints in each fold 
for i in range(num_points):
    temp = []
    # get that value from each fold 
    for j in range(num_folds):
        temp.append(scores[i + num_points*j])
    means.append(np.mean(temp))
# get the max value
max_value = max(means)
max_index = means.index(max_value)
# get best SCCS data
print("best mean SCCS score:", scores[max_index])
print("best SCCS model", paths[max_index])
