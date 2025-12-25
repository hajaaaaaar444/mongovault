# 1. Use Python 3.11 (Debian 12 Bookworm)
FROM python:3.11-slim

# 2. Install dependencies (Curl, GPG, Unzip)
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 3. Install MongoDB 7.0 Tools (The Modern Way)
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor \
    && echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" | \
    tee /etc/apt/sources.list.d/mongodb-org-7.0.list \
    && apt-get update \
    && apt-get install -y mongodb-org-tools \
    && rm -rf /var/lib/apt/lists/*

# 4. Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# 5. App Setup
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN chmod +x backup_script.sh

EXPOSE 8501

CMD ["streamlit", "run", "dashboard.py", "--server.port=8501", "--server.address=0.0.0.0"]
