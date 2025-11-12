# Dockerfile for running tests
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy test files
COPY tests/ ./tests/
COPY pages/ ./pages/
COPY conftest.py .
COPY pytest.ini .

# Create directory for allure reports
RUN mkdir -p allure-results

ENTRYPOINT ["pytest"]
