# Use a base image with all necessary compilers
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Copy your Django project files to the container
COPY . .

ENV POETRY_VIRTUALENVS_CREATE=false

# RUN mkdir -p /app/media/cache
# RUN chmod -R 755 /app/media/cache
# RUN mkdir -p /app/media/files
# RUN chmod -R 755 /app/media/files

# Install Python dependencies
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install poetry
RUN poetry install

# Collect static files (optional)
# RUN python manage.py collectstatic --noinput
RUN python manage.py makemigrations
RUN python manage.py migrate
RUN python manage.py makemigrations api
RUN python manage.py migrate api

RUN chmod +x /app/entrypoint.sh

# Expose the port the Django app runs on
EXPOSE 8000

# Set environment variables for Django
ENV DJANGO_SETTINGS_MODULE=config.settings
ENV PYTHONUNBUFFERED=1
ENTRYPOINT ["/app/entrypoint.sh"]
# Run Django server (for development, use `gunicorn` for production)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# CMD ["uvicorn","--host","0.0.0.0","config.asgi:application","--loop", "uvloop"]
