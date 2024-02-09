# Download the model
wget "$MODEL_URL" --content-disposition -O model.safetensors

# Download the script to convert the model from safetensors to diffusers
wget "https://raw.githubusercontent.com/huggingface/diffusers/v0.26.0/scripts/convert_original_stable_diffusion_to_diffusers.py"

# Convert the model
python convert_original_stable_diffusion_to_diffusers.py --checkpoint_path model.safetensors --dump_path SDModel/ --from_safetensors

# Set environment variables
export MODEL_NAME=SDModel
export INSTANCE_DIR=faces
export OUTPUT_DIR=$OUTPUT_MODEL

# Download the dataset
wget "$DATASET_URL" --content-disposition -O dataset.zip

# Create the instance directory
mkdir $INSTANCE_DIR

# Unzip the dataset
unzip dataset.zip -d $INSTANCE_DIR

# Remove all files that aren't images
find $INSTANCE_DIR -type f ! -name "*.jpg" -delete

# Remove all empty directories
find $INSTANCE_DIR -type d -empty -delete

# Train the model
accelerate launch train_dreambooth.py \
      --pretrained_model_name_or_path=$MODEL_NAME  \
      --instance_data_dir=$INSTANCE_DIR \
      --output_dir=$OUTPUT_DIR \
      --instance_prompt="sks $INSTANCE_NAME" \
      --resolution=512 \
      --train_batch_size=1 \
      --gradient_accumulation_steps=1 \
      --learning_rate=5e-6 \
      --lr_scheduler="constant" \
      --lr_warmup_steps=0 \
      --max_train_steps=$TRAINING_STEPS \
      --push_to_hub
