FROM pytorch:latest

# Set the working directory
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/huggingface/diffusers

# Set the working directory
WORKDIR /app/diffusers

# Install the requirements
RUN pip install -e .

# Set the working directory
WORKDIR /app/diffusers/examples/dreambooth

# Install the requirements
RUN pip install -r requirements.txt

# Configure accelerate
RUN accelerate config default

# Copy the script
COPY script.sh .

# Run script.sh
ENTRYPOINT ["bash", "script.sh"]
