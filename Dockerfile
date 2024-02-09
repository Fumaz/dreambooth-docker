FROM pytorch/pytorch:latest

# Set the working directory
WORKDIR /app

# Install git, gcc, and g++
RUN apt-get update && apt-get install -y git gcc g++

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

# Copy the script
COPY script.sh .

RUN apt install -y unzip wget

# Run script.sh
ENTRYPOINT ["bash", "script.sh"]
