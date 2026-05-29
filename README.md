# ClickHouse homework

Домашняя работа по ClickHouse: поднять ClickHouse в Docker, создать базу `homework`, таблицу `homework.metrika`, загрузить файл `metrika_sample.tsv` и найти пользователя, который сделал больше всего просмотров страниц.

## Что внутри

- `docker-compose.yml` - запускает ClickHouse Server в Docker.
- `data/metrika_sample.tsv` - исходные данные для загрузки.
- `sql/01_create_schema.sql` - создает базу `homework` и таблицу `homework.metrika`.
- `sql/02_top_user.sql` - считает пользователя с максимальным количеством просмотров.

## Команды для запуска

1. Перейти в папку проекта:

```bash
cd ClickHouse_HW
```

2. Запустить ClickHouse:

```bash
docker compose up -d
```

Команда скачивает образ ClickHouse, создает контейнер `clickhouse_hw` и запускает сервер в фоне.

3. Проверить, что ClickHouse отвечает:

```bash
docker compose exec clickhouse clickhouse-client --query "SELECT 1"
```

Если все работает, команда вернет `1`.

4. Создать базу и таблицу:

```bash
docker compose exec -T clickhouse clickhouse-client --multiquery < sql/01_create_schema.sql
```

Команда выполняет SQL из файла `sql/01_create_schema.sql`: создает базу `homework` и таблицу `homework.metrika`.

5. Загрузить данные из TSV:

```bash
docker compose exec -T clickhouse clickhouse-client --database homework --query "INSERT INTO metrika FORMAT TSV" < data/metrika_sample.tsv
```

Команда передает локальный файл `data/metrika_sample.tsv` внутрь `clickhouse-client` и вставляет строки в таблицу `homework.metrika`.

6. Проверить количество загруженных строк:

```bash
docker compose exec clickhouse clickhouse-client --query "SELECT count() FROM homework.metrika"
```

Ожидаемый результат:

```text
100000
```

7. Найти пользователя с максимальным количеством просмотров:

```bash
docker compose exec clickhouse clickhouse-client < sql/02_top_user.sql
```

Ожидаемый результат:

```text
1313448155240738815	4439
```

Ответ: пользователь `1313448155240738815` сделал больше всего просмотров страниц - `4439`.

## Как остановить контейнер

Остановить ClickHouse:

```bash
docker compose down
```

Остановить ClickHouse и удалить локальные данные контейнера:

```bash
docker compose down -v
```

`-v` удаляет Docker volume с данными ClickHouse. После этой команды таблицу и данные нужно будет создавать заново.
