# Imagen base con Python
FROM python:3.12-slim AS base
WORKDIR /app


# Instalamos las dependencias
COPY requirements.txt .
RUN pip install -r requirements.txt



# Ejecutamos los tests, si fallan el build para
FROM base AS test
COPY . .
RUN pip install -r requirements-dev.txt
CMD ["pytest", "-v"]



# Servidor de desarrollo
FROM base AS dev
COPY . .
EXPOSE 5000
CMD ["flask", "--app", "run", "run", "--debug"]



# Imagen final con Python, copiamos el código fuente
FROM base AS production
COPY . .
EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "run:app"]