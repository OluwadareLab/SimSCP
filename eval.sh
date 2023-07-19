#!/bin/bash

# THESE STAY CONSTANT FOR EACH EXPERIMENT 
OUT_DIR="/storage/store/kevin/local_files/exp1/"
SPLIT_DIR="${OUT_DIR}/SPLITS/"

# use this to determine which pre-trained checkpoints should be used for fine-tuneing
OUT_DIRS1=("${OUT_DIR}")

# use once the chosen checkpoints have been fine-tuned
OUT_DIRS2=(
  "${OUT_DIR}/BEST_SCCS/"
  "${OUT_DIR}/BEST_NMI/"
  "${OUT_DIR}/BASELINE/"
)

# make SPLIT_DIR if it does not exist
mkdir -p "$SPLIT_DIR"
echo "SPLIT_DIR at $SPLIT_DIR"

# adjust OUT_DIRS# based on usage 
for OUT_DIR in "${OUT_DIRS2[@]}"; do
  echo "Running eval.sh at $OUT_DIR"

  # Make a results directory if it does not already exist
  mkdir -p "${OUT_DIR}/results/"

  # Generate NMI data
  echo "Generating NMI data!" 
  python eval_NMI.py --out_dir "${OUT_DIR}" --layer "last"
  echo "Finished generating NMI data!"

  # Generate SCCS data
  echo "Generating SCCS data!"
  python eval_SCCS.py --out_dir "${OUT_DIR}" --split_dir "${SPLIT_DIR}"
  echo "Finished generating SCCS data!"

  # Generate F1 scores for fine-tuned models 
  echo "Generating F1 scores!"
  python eval_F1.py --out_dir "${OUT_DIR}" --split_dir "${SPLIT_DIR}"
  echo "Finished generating F1 scores!"

  # Make a boxplot of the best model's performance on the test data
  echo "Generating boxplot!"
  python eval_boxplot.py --out_dir "${OUT_DIR}"
  echo "Finished generating boxplot!"

  current_datetime=$(date +"%Y-%m-%d %H:%M:%S")
  echo "eval.sh completed at time: ${current_datetime} for ${OUT_DIR}!"
done