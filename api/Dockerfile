FROM python:3.11-slim

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY ./app /code/app
# fastapi port
# EXPOSE 8000

# CMD ["fastapi","dev","main.py"]
CMD ["fastapi", "run", "app/main.py", "--port", "80"]
