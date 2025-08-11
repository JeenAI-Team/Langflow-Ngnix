# syntax=docker/dockerfile:1
ARG LANGFLOW_IMAGE=langflowai/langflow
FROM $LANGFLOW_IMAGE

USER root

# Upgrade SQLite to 3.50.3 (fixes CVE-2025-6965 and more)
RUN apt-get update && \
    apt-get install -y wget build-essential libreadline-dev libsqlite3-dev && \
    wget https://www.sqlite.org/2025/sqlite-autoconf-3500300.tar.gz && \
    tar xzf sqlite-autoconf-3500300.tar.gz && \
    cd sqlite-autoconf-3500300 && \
    ./configure --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf sqlite-autoconf-* && \
    sqlite3 --version


    #Mount a custom Folder with Custom Components
# COPY C:/Users/NisimOhana/Desktop/JeenComponents /app/custom_components

#Added ENV:
    #LANGFLOW_COMPONENTS_PATH = /app/custom_components

    # Optional: remove frontend
RUN rm -rf /app/.venv/langflow/frontend

CMD ["python", "-m", "langflow", "run", "--host", "0.0.0.0", "--port", "7860", "--backend-only"]
