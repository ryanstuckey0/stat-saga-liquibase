# stat-saga-liquibase

## Helpful Links and Documentation

- [Choosing Liquibase project layout](https://docs.liquibase.com/start/design-liquibase-project.html)
- [createTable Reference](https://docs.liquibase.com/change-types/create-table.html#yaml_example)
- [Setting schema to use](https://docs.liquibase.com/parameters/liquibase-schema-name.html)
- [Preconditions](https://docs.liquibase.com/concepts/changelogs/preconditions.html#json_example_changeLogPropertyDefined)

## Project Structure

Project is organized by database object type (e.g., tables, index, etc.).

- Tables- [changelog/table](changelog/table/)
- Indices- [changelog/index](changelog/index/)

## Local testing

These changes can be tested locally by going into the test directory and running the `test.sh` script. This script will perform a couple actions:
1. Start up Liquibase's included H2 database via `liquibase init start-h2`
2. Runs the changelog located at [test/init/changelog-init.yml](test/init/changelog-init.yml), which initializes the database with the `statsaga` schema as well as grant permissions to the `liquibase` user. This step is only performed in a local env.
3. Runs the entire changelog located at [changelog-root.yml](changelog-root.yml), which is the same changelog that would be run in a live environment. This will perform all setup needed for the application, including creating tables, users, etc.
4. Wait for user input of either `b` or `k`, where `b` opens in H2 console in a brower while `k` will shutdown the H2 database.
While this script is running, your Spring app can then point to the H2 database with the following configuration:
```yaml
spring:
  datasource:
    url: jdbc:h2:tcp://localhost:9090/mem:dev
    username: backend_user
    password: letmein
```