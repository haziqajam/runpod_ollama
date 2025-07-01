# Use an official base image with your desired version
FROM ollama/ollama:latest

ENV PYTHONUNBUFFERED=1 

# Set up the working directory
WORKDIR /

# Base packages
RUN apt-get update --yes --quiet && DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
    software-properties-common \
    gpg-agent \
    build-essential \
    apt-utils \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Add deadsnakes and install Python 3.11
RUN add-apt-repository --yes ppa:deadsnakes/ppa && apt-get update --yes --quiet && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
    python3.11 \
    python3.11-dev \
    python3.11-distutils \
    python3.11-lib2to3 \
    python3.11-gdbm \
    python3.11-tk \
    python3-pip

# Set Python 3.11 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    ln -sf /usr/bin/python3 /usr/bin/python

# Upgrade pip
RUN pip install --upgrade pip

# Add your files
ADD . .

RUN pip install runpod

# Override Ollama's entrypoint
ENTRYPOINT ["bin/bash", "start.sh"]

CMD ["gemma3n:e4b"]
