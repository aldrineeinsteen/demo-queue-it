FROM python:3.9

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY queue_consumer.py config.py .

CMD ["python", "queue_consumer.py"]