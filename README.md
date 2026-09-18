# Анализатор качества репозиториев (Rails)

[![CI](https://github.com/mikitasazan/rails-project-66/actions/workflows/ci.yml/badge.svg)](https://github.com/mikitasazan/rails-project-66/actions/workflows/ci.yml)

Учебный проект Хекслета: сервис следит за качеством репозиториев на GitHub —
добавляет репозиторий, запускает проверку линтером по кнопке или по вебхуку
и показывает отчёт с замечаниями.

## Демонстрационный проект

Примеры интерфейса готового приложения: [демонстрация](https://files.hexlet.app/a/klff0i).

## Стек

- Ruby 4.0, Rails 8.1
- SQLite3 (разработка и тесты), PostgreSQL (продакшен)
- Tailwind CSS, esbuild, Turbo
- OmniAuth (GitHub), Octokit, AASM, dry-container, enumerize
- Minitest + power_assert, Rubocop, herb-lint
- Sentry (DSN из переменной окружения SENTRY_DSN)

## Использование

```bash
make setup   # зависимости, сборка фронтенда, база данных
make start   # веб-сервер на http://localhost:3000
```

Переменные окружения (см. `.env.example`): `GITHUB_CLIENT_ID`,
`GITHUB_CLIENT_SECRET`, `SENTRY_DSN`.

Проверка качества:

```bash
make test    # тесты minitest
make lint    # rubocop + herb-lint
```
