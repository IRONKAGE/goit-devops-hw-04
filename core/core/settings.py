import os
from pathlib import Path

# 1. Визначаємо базову директорію проекту
BASE_DIR = Path(__file__).resolve().parent.parent

# 2. Безпека: Секретний ключ (краще тримати в .env, але додамо fallback для розробки)
SECRET_KEY = os.environ.get('SECRET_KEY', 'django-insecure-debug-key-12345')

# 3. Режим відладки (Debug)
DEBUG = int(os.environ.get('DEBUG', 1))

# 4. Дозволені хости (Важливо для Nginx та Docker)
ALLOWED_HOSTS = ['localhost', '127.0.0.1', 'django', '0.0.0.0']

# 5. Списки додатків (Стандартний набір Django)
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    # Тут можна додати свої додатки
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'core.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'core.wsgi.application'

# 6. Конфігурація Бази Даних (PostgreSQL для Docker)
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('POSTGRES_DB', 'django_db'),
        'USER': os.environ.get('POSTGRES_USER', 'db_admin'),
        'PASSWORD': os.environ.get('POSTGRES_PASSWORD', 'strong_password'),
        'HOST': os.environ.get('POSTGRES_HOST', 'db'),
        'PORT': os.environ.get('POSTGRES_PORT', '5432'),
    }
}

# 7. Валідація паролів (Стандарт Django)
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]

# 8. Локалізація
LANGUAGE_CODE = 'uk-ua'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# 9. СТАТИЧНІ ФАЙЛИ (Налаштування для Nginx)
STATIC_URL = 'static/'
# Папка, куди Django збере всі файли для Nginx під час collectstatic
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
