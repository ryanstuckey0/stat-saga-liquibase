# stat-saga-liquibase

## Overview

The project is organized into two main folders:
- [changelog](changelog/) contains all changelogs
- [deploy](deploy/) contains various Liquibase property files for each env 
- 
I was unsure of the best way to organize the project, specifically how to handle the different properties for the various envs I will be deploying to. I think this works for now, but eventually I might switch to a parameterized deployment, where I activate a set of env variables for the specific env we are deploying to.

I am also currently just running the `liquibase update` and other commands locally, but I will eventually switch to a CI/CD pipeline (possibly GitHub Actions).

Finally, the database credentials are currently in the files, but these databases are only running in my local env. Eventually once I deploy outside my network I need to figure out how to handle the secrets.

## Helpful Links and Documentation

- [Choosing Liquibase project layout](https://docs.liquibase.com/start/design-liquibase-project.html)
- [createTable Reference](https://docs.liquibase.com/change-types/create-table.html#yaml_example)
- [Setting schema to use](https://docs.liquibase.com/parameters/liquibase-schema-name.html)
- [Preconditions](https://docs.liquibase.com/concepts/changelogs/preconditions.html#json_example_changeLogPropertyDefined)

## Project Structure

Project changelogs are organized into folders by database object type (e.g., tables, index, etc):
- Tables- [changelog/table](changelog/table/)
- Users- [changelog/user](changelog/user/)

Additionally, I have created a folder for each different environment Liquibase can be used with. Each folder also contains an `init` folder, which contains a mini-Liquibase deployment that handles database initializing. Database initialization really only consists of creating the schema and Liquibase user, and then assigning permissions to the Liquibase user. 
- Local- H2 running locally- [deploy/local-h2](deploy/local-h2/)
- Test- MySQL running in k3s on Raspberry Pi- [deploy/test-k3s-mysql](deploy/test-k3s-mysql/)

## Local testing

These changes can be tested locally by going into the test directory and running the `test.sh` script. The script is useful for quickly testing changes to the database schema and making sure they deploy okay with Liquibase. The script will start H2 in MySQL compatibility mode, since that is the database I use in live environments. 

This script will perform a couple actions:
1. Start up Liquibase's included H2 database via `liquibase init start-h2`
2. Runs the changelog located at [deploy/local-h2/init/changelog-init.yml](deploy/local-h2/init/changelog-init.yml), which initializes the database with the `statsaga` schema as well as grant permissions to the `liquibase` user. This step is only performed in a local env.
3. Runs the changelog located at [deploy/local-h2/changelog.yml](deploy/local-h2/changelog.yml), which is the same behavior that would be run in a live environment (e.g., test, prod). This will perform all setup needed for the application, including creating tables, users, etc.
4. Wait for user input of `b`, `r`, or `k`:
     - `b`- open H2 console in browser
     - `r`- restart H2 from scratch and run Liquibase scripts; useful for iterative development and quick testing of DB changes
     - `k`- shutdown H2 and stop script

While this script is running, your Spring app can then point to the H2 database with the following configuration:
```yaml
spring:
  datasource:
    url: jdbc:h2:tcp://localhost:9090/mem:dev
    username: backend_user
    password: letmein
```