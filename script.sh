# Configure accelerate
accelerate config default

# Set environment variables
export INSTANCE_DIR=faces
export OUTPUT_DIR=$OUTPUT_MODEL

# Download the dataset
wget "$DATASET_URL" --content-disposition -O dataset.zip

# Create the instance directory
mkdir $INSTANCE_DIR

# Unzip the dataset
unzip dataset.zip -d $INSTANCE_DIR

# Train the model
accelerate launch train_dreambooth.py \
      --pretrained_model_name_or_path="$MODEL_NAME"  \
      --instance_data_dir=$INSTANCE_DIR \
      --output_dir="$OUTPUT_DIR" \
      --instance_prompt="sks $INSTANCE_NAME" \
      --resolution=512 \
      --train_batch_size=1 \
      --gradient_accumulation_steps=1 \
      --learning_rate=5e-6 \
      --lr_scheduler="constant" \
      --lr_warmup_steps=0 \
      --max_train_steps=$TRAINING_STEPS

# Upload the model
cd "$OUTPUT_DIR" || exit

# If $PRIVATE is true, create a private repo
if [ "$PRIVATE" = true ]; then
  huggingface-cli repo create "$OUTPUT_MODEL" --type model --private
else
  huggingface-cli repo create "$OUTPUT_MODEL" --type model
fi

git lfs install
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin "https://huggingface.co/$HF_USERNAME/$OUTPUT_MODEL"
git push -u origin main
