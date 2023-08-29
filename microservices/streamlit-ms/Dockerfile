FROM python:3.8-slim

RUN pip3 install --no-cache-dir --upgrade \
    pip \ 
    virtualenv

RUN apt-get update && apt-get install -y \
    build-essential \
    software-properties-common \
    git

WORKDIR /app

COPY . /app

ENV VIRTUAL_ENV=/app/venv
RUN virtualenv ${VIRTUAL_ENV}
RUN . ${VIRTUAL_ENV}/bin/activate && pip install -r /app/requirements.txt

# Entando settings
## Required port for microservices
EXPOSE 8081
## Context path is provided by the engine based on the bundle id
ENV SERVER_SERVLET_CONTEXT_PATH=/default

COPY run.sh /app
ENTRYPOINT ["./run.sh"]