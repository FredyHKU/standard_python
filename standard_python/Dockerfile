# Dockerfile
FROM python:3.11.7-slim

# Update pip
RUN pip config set global.extra-index-url "https://mirrors.cernet.edu.cn/pypi/web/simple" \
    && pip install --upgrade pip

# Set work directory
WORKDIR /runprogram

# Copy requirements files and install packages
COPY requirements.txt /runprogram/	
RUN chmod -R 755 /runprogram \
    && pip install --no-cache-dir -r requirements.txt \
    && rm -rf /var/lib/apt/lists/*
	
# Copy all files from the current directory to the workdir in the container
COPY . /runprogram

RUN chmod  -R 755 /runprogram
