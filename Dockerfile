# Використовуємо офіційний легкий образ
FROM python:3.11-slim

# Встановлюємо змінні середовища для оптимізації Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_HOME=/app

# Встановлюємо робочу директорію
WORKDIR $APP_HOME

# Створюємо непривілейованого користувача (Security Best Practice)
RUN addgroup --system appuser && adduser --system --group appuser

# Встановлюємо системні залежності (для PostgreSQL)
RUN apt-get update && apt-get install -y netcat-traditional && rm -rf /var/lib/apt/lists/*

# Копіюємо та встановлюємо залежності
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо код проекту та скрипт запуску
COPY ./core $APP_HOME/
COPY ./entrypoint.sh $APP_HOME/

# Надаємо права на скрипт запуску та змінюємо власника папки
RUN chmod +x $APP_HOME/entrypoint.sh && \
    chown -R appuser:appuser $APP_HOME

# Перемикаємось на безпечного користувача
USER appuser

# Визначаємо скрипт, який виконається при старті
ENTRYPOINT ["/app/entrypoint.sh"]
