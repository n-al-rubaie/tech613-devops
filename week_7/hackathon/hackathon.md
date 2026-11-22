# The Sparta AI Huddle Hackathon - 11th November 2026 - London

## Overview

The Sparta Global AI Huddle Hackathon, held on 11 November 2026 in London, involved developing practical solutions to real-world business challenges provided by three major client organisations: Accenture, HMRC and the Home Office.

At the end of the day, we presented our final solution to an audience of over 100 people, including representatives from the client organisations.

I worked in a multidisciplinary team alongside members from AI Engineering, Data Engineering, DevOps, Business Solutions and Test Automation.

[Read the full hackathon coverage on Sparta Global's website](https://www.spartaglobal.com/insights/the-sparta-ai-huddle-returns-bringing-ai-people-and-innovation-together/).

## Our Project - PetClinic

- **Client:** Home Office
- **Project:** PetClinic
- **Objective:** Explore how AI-assisted quality engineering could improve the testing of a pet clinic application.

Our team worked on the PetClinic application and explored how automated testing and AI-assisted quality engineering could help improve software quality.

[View the team's GitHub repository](https://github.com/spartaglobal/petclinic-2026-team-london).

## My Contributions

My individual contribution focused on **backend pipeline automation**. I added and modified specific steps in the existing GitHub Actions workflow to automate backend testing, API testing and code coverage checks.

[View my GitHub commits](https://github.com/spartaglobal/petclinic-2026-team-london/commits?author=n-al-rubaie).

## Backend Pipeline Automation

### What is Maven?

Maven is a build automation tool commonly used in Java projects. It automates tasks such as compiling code, running tests and packaging applications.

In this project, Maven was used to:

- Run backend unit tests.
- Build and package the Spring Boot application into a JAR file.
- Generate and check code coverage using JaCoCo.

The project used the **Maven Wrapper (`mvnw`)**, which allows the project to use its specified Maven version without requiring a separate Maven installation.

### 1. Backend Unit Tests

I added steps to make the Maven Wrapper executable and run the backend unit tests.

```yaml
- name: Make Maven wrapper executable
  run: chmod +x spring-petclinic-rest/mvnw

- name: Run tests
  working-directory: spring-petclinic-rest
  run: ./mvnw test
```

**What these steps do and why:**

- `chmod +x`: Gives the Maven Wrapper permission to execute in the GitHub Actions environment.
- `working-directory`: Sets the directory where the Maven commands will run.
- `./mvnw test`: Uses Maven to compile the backend code and execute its unit tests.

**Why this matters:** Running unit tests automatically helps identify problems in the backend code whenever the pipeline runs.

### 2. Backend Newman API Tests

I added steps to build the backend application, start the API and execute automated API tests using Newman.

#### Build the application

```yaml
- name: Build jar
  working-directory: spring-petclinic-rest
  run: ./mvnw -DskipTests package
```

**What it does:**

- `package`: Compiles the Java application and packages it into a JAR file.
- `-DskipTests`: Skips running the tests during this build because the unit tests are handled separately.

**Why this matters:** The application needs to be built into a JAR file before it can be started for API testing.

#### Start the API

```yaml
- name: Start API
  working-directory: spring-petclinic-rest
  run: |
    nohup java -jar target/*.jar > api.log 2>&1 &
    for i in $(seq 1 30); do
      curl -sf http://localhost:9966/petclinic/actuator/health && exit 0
      sleep 2
    done
    echo "API did not start"; cat api.log; exit 1
```

**What it does:**

- `java -jar target/*.jar`: Starts the Spring Boot application using the generated JAR file.
- `nohup` and `&`: Allow the application to continue running in the background.
- `> api.log 2>&1`: Saves application output and errors to a log file.
- `curl`: Sends a request to the Spring Boot Actuator health endpoint to check whether the API is responding.
- `sleep 2`: Waits two seconds before checking again.
- The loop checks up to 30 times before reporting that the API failed to start.

**Why this matters:** The API needs to be running and responding before Newman can execute the API tests. The health check helps prevent tests from starting before the application is ready.

#### Run Newman API tests

```yaml
- name: Run Newman
  run: |
    npx --yes newman@6 run spring-petclinic-rest/src/test/postman/petclinic-nonregressiontests.postman_collection.json \
      --reporters cli,junit \
      --reporter-junit-export spring-petclinic-rest/src/test/postman/reports/newman.xml
```

**What is Newman?**

Newman is a command-line tool that runs Postman collections. It allows API tests created in Postman to be executed automatically, including inside a CI/CD pipeline.

**What the command does:**

- `npx`: Runs a Node.js package without requiring a global installation.
- `newman@6`: Uses Newman version 6.
- `run`: Executes the specified Postman collection.
- `--reporters cli,junit`: Produces test results in the terminal and JUnit XML format.
- `--reporter-junit-export`: Specifies where the JUnit test report is saved.

**Why this matters:** It allows the backend API to be tested automatically, helping identify issues with API functionality and existing endpoints.

### 3. JaCoCo Code Coverage

I added JaCoCo report generation and a coverage gate to the backend workflow.

**What is JaCoCo?**

JaCoCo is a Java code coverage tool. It measures how much of the application's code is executed when tests run.

I added the following steps:

```yaml
- name: Coverage report
  working-directory: spring-petclinic-rest
  run: ./mvnw jacoco:report

- name: Coverage gate
  working-directory: spring-petclinic-rest
  run: ./mvnw jacoco:check
```

**What these steps do:**

- `jacoco:report`: Generates a report showing how much of the code was executed by the tests.
- `jacoco:check`: Checks whether the measured coverage meets the minimum thresholds configured in the project's `pom.xml`.

**Why this matters:** Code coverage helps show which parts of the application are being tested. The coverage gate can also prevent the pipeline from passing when coverage falls below the configured minimum.

#### Coverage thresholds

I also adjusted the minimum coverage thresholds in the `pom.xml` configuration while troubleshooting the coverage gate.

| Coverage type | Minimum threshold |
|---|---:|
| Line coverage | 5% |
| Branch coverage | 1% |

- **Line coverage:** Measures the proportion of executable lines that were run by tests.
- **Branch coverage:** Measures the proportion of decision paths tested, such as the true and false outcomes of an `if` statement.

These were low minimum thresholds configured for the existing project's test coverage. They should not be interpreted as high overall test coverage.

### 4. Pipeline Validation

I checked the GitHub Actions workflow after making my changes.

Both backend jobs completed successfully:

### Backend - Unit tests & coverage gate:

![alt text](<Backend - unit tests and coverage gate.png>)

### Backend - Postman/Newman API tests:
  
![alt text](<Backend - postman newman api tests.png>)


This helped verify that the added backend testing and coverage steps worked successfully in the GitHub Actions environment.