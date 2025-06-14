# stat-saga-liquibase

## Helpful Links and Documentation

- [Choosing Liquibase project layout](https://docs.liquibase.com/start/design-liquibase-project.html)
- [createTable Reference](https://docs.liquibase.com/change-types/create-table.html#yaml_example)
- [Setting schema to use](https://docs.liquibase.com/parameters/liquibase-schema-name.html)
- [Preconditions](https://docs.liquibase.com/concepts/changelogs/preconditions.html#json_example_changeLogPropertyDefined)

## Project Structure

Project is organized by database object type (e.g., tables, index, etc.).

- Tables- [changelogs/table/](changelogs/table/)
- Indices- [[changelogs/index/](changelogs/index/)]