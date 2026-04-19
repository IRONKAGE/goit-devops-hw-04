# goit-devops-hw-04

***Технiчний опис завдань***

# **Завдання 4: Docker**

## **Опис завдання:**

1. Створіть власний проєкт, що включає:
   - **Django** — для вебзастосунку
   - **PostgreSQL** — для збереження даних
   - **Nginx** — для обробки запитів
2. Використайте `Docker` і `Docker Compose` для контейнеризації всіх сервісів.
3. Запуште проєкт у свій репозиторій на `GitHub` для перевірки.

## **Кроки виконання завдання:**

1. **Створіть структуру проєкту `Django` в `Docker`:**
   - Ініціалізуйте новий Django-проєкт (назва проєкту на ваш вибір)
   - Налаштуйте **PostgreSQL як базу даних**
   - **Додайте Nginx** для проксирування трафіку

2. **Створіть Dockerfile для Django:**

Ваш Dockerfile повинен:

   - Використовувати образ `Python 3.9` або новіший
   - Встановлювати всі необхідні залежності з **requirements.txt**
   - Запускати `Django`-сервер у контейнері

3. **Створіть docker-compose.yml:**

У **docker-compose.yml** опишіть усі три сервіси:

   - *web* — `Django`-застосунок
   - *db* — `PostgreSQL` для збереження даних
   - *nginx* — вебсервер для обробки запитів

***Налаштуйте Nginx***

Створіть файл **nginx.conf** у папці **nginx** з таким вмістом:

```nginx
   server {
      listen 80;

      location / {
         proxy_pass http://django:8000;
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      }
   }
```

4. **Протестуйте проєкт локально:**

Запустіть проєкт за допомогою команди:

```bash
   docker-compose up -d
```

Переконайтеся, що:

   - Вебзастосунок доступний за адресою [http://localhost](http://localhost)
   - Підключення до бази даних `PostgreSQL` працює

5. **Запуште проєкт у GitHub:**

   - Створіть нову гілку lesson-4 у вашому репозиторії
   - Завантажте всі файли вашого проєкту в репозиторій
   - Використовуйте такі команди для завантаження змін:

```bash
   git checkout -b lesson-4
   git add .
   git commit -m "Add Dockerized Django project with PostgreSQL and Nginx"
   git push origin lesson-4
```

**Проєкт має включати:**

   - `Dockerfile`
   - `docker-compose.yml`

Конфігураційний файл `nginx.conf`:

   - `Django`-код із налаштуваннями бази даних `PostgreSQL`


**Структура проекту:**

```md
goit-devops-hw-04/
├── .env                  # (Секрети - не додаємо в Git, але вони все ж будуть тут у файлі ReadMe.md для відтворюваності і тесту...)
├── .gitignore            # Правила ігнорування
├── docker-compose.yml    # Головна оркестрація
├── Dockerfile            # Інструкція для збірки Django
├── entrypoint.sh         # Скрипт ініціалізації (God Mode)
├── requirements.txt      # Залежності Python
├── nginx/
│   └── nginx.conf        # Конфіг проксі (з урахуванням статики)
└── core/                  <-- Зовнішня папка (контейнер проекту)
    ├── manage.py          <-- Головний скрипт управління
    └── core/              <-- Внутрішня папка (головний Python-пакет проєкту)
        ├── __init__.py
        ├── asgi.py
        ├── settings.py
        ├── urls.py
        └── wsgi.py
```

**Секрети фалу `.env`:**

```env
DEBUG=1
SECRET_KEY=super-secret-key-for-dev
POSTGRES_DB=django_db
POSTGRES_USER=db_admin
POSTGRES_PASSWORD=strong_password
POSTGRES_HOST=db
POSTGRES_PORT=5432
```
