FROM python:3.9

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY queue_producer.py .

CMD ["uvicorn", "queue_producer:app", "--host", "0.0.0.0", "--port", "8000"]