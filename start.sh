#!/bin/sh
# ==============================================================================
# MLOps Omni-Starter (Universal Docker Health-Check)
# Архітектура: Коментарі українською, stdout англійською для 100% сумісності.
# Підтримує: systemd, OpenRC (Alpine/Gentoo), runit (Void), sysvinit (Legacy),
#            Lima (BSD/macOS), Docker Desktop (Win/Mac), Docker Toolbox (Win 7).
# ==============================================================================

printf "\n===> [1/2] Checking Docker Engine health...\n"

# 1. Перевірка чи встановлено CLI взагалі
if ! command -v docker >/dev/null 2>&1; then
    printf "[CRITICAL ERROR] Docker CLI is not found on this system.\n"
    printf "Please run the appropriate IaC provisioner for your OS.\n"
    exit 1
fi

# 2. Інтелектуальна діагностика Демона
if ! DOCKER_ERR=$(docker ps 2>&1 >/dev/null); then
    printf "[WARNING] DOCKER IS INSTALLED, BUT THE DAEMON IS UNREACHABLE!\n\n"
    OS_TYPE=$(uname -s)

    # Сценарій А: Проблема з правами доступу
    if echo "$DOCKER_ERR" | grep -qi "permission denied"; then
        printf "  [Issue] Permission Denied: Your user cannot read the Docker socket.\n"
        printf "  [Fix]   Run: newgrp docker\n"

    # Сценарій Б: TLS помилка (Специфічно для Docker Toolbox на Legacy Windows)
    elif echo "$DOCKER_ERR" | grep -qi "error during connect\|tls"; then
        printf "  [Issue] TLS Connection Error (Likely Docker Toolbox / Legacy Engine).\n"
        printf "  [Fix]   Please run this project from the 'Docker Quickstart Terminal'.\n"

    # Сценарій В: Демон лежить (Адаптивний аналіз Init-систем)
    else
        printf "  [Issue] Docker daemon is not running.\n"
        printf "  [Fix for your specific environment]:\n"

        # Перевірка на Lima (UNIX / BSD / macOS)
        if command -v limactl >/dev/null 2>&1; then
            printf "   -> BSD/macOS (Lima VM): Run 'limactl start docker'\n"
            printf "      And ensure DOCKER_HOST is exported.\n"

        elif [ "$OS_TYPE" = "Darwin" ]; then
            printf "   -> macOS: Launch 'Docker Desktop' from Applications.\n"

        elif [ "$OS_TYPE" = "Linux" ]; then
            if grep -qi microsoft /proc/version 2>/dev/null; then
                printf "   -> Windows (WSL): Launch 'Docker Desktop' in your Windows host.\n"
            elif command -v systemctl >/dev/null 2>&1; then
                printf "   -> Linux (systemd): Run 'sudo systemctl start docker'\n"
            elif command -v rc-service >/dev/null 2>&1; then
                printf "   -> Alpine/Gentoo (OpenRC): Run 'sudo rc-service docker start'\n"
            elif command -v sv >/dev/null 2>&1; then
                printf "   -> Void Linux (runit): Run 'sudo sv start docker'\n"
            else
                printf "   -> Legacy Linux (sysvinit): Run 'sudo service docker start'\n"
            fi

        else
            printf "   -> Windows/Other: Ensure Docker Desktop or Daemon is running.\n"
        fi
    fi
    printf "\n⏳ Please fix the issue and run this script again.\n"
    exit 1
fi

printf "[OK] Docker Engine is active and ready!\n"

# ==========================================
# 3. АВТОВИЗНАЧЕННЯ ВЕРСІЇ COMPOSE ТА ЗАПУСК
# ==========================================
printf "\n===> [2/2] Building and starting the project...\n"

# Новий синтаксис (Docker Compose V2 - стандарт де-факто)
if docker compose version >/dev/null 2>&1; then
    printf "[INFO] Using: Docker Compose V2 (Native)\n"
    docker compose up -d --build

# Старий синтаксис (docker-compose V1 - спадкові системи)
elif docker-compose --version >/dev/null 2>&1; then
    printf "[INFO] Using: docker-compose V1 (Legacy)\n"
    docker-compose up -d --build

# Якщо плагін не знайдено взагалі
else
    printf "[CRITICAL ERROR] Compose plugin not found!\n"
    exit 1
fi

printf "\n[SUCCESS] Project deployed successfully! Environment is up and running.\n"
