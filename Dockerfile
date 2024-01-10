
# Use the official Python base image
# Render requires the --platform flag to be set to linux/amd64
# https://docs.render.com/deploy-an-image#image-requirements
FROM --platform=linux/amd64 python:3.10

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file into the container
COPY requirements.txt .

# Install the Python packages listed in the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt

# Install FFmpeg and clean up in one layer
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Copy the rest of the Django project into the container
COPY . .

# Set the environment variable for Django to run in production mode
ENV DJANGO_SETTINGS_MODULE=mysite.settings

# Expose the port on which the Django app will run
EXPOSE 8000

# Run the Django app
ENTRYPOINT ["python3", "manage.py", "runserver", "0.0.0.0:8000"]