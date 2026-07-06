# Student Assessment and Record System (SARS)
### Comprehensive Assignment Implementation Report

---

## Table of Contents
1. [Part 1: Relational Database Design and SQL Querying](#part-1-relational-database-design-and-sql-querying)
    - [Task 1.1: Normalization Analysis](#task-1-1-normalization-analysis)
    - [Task 1.2: Schema Implementation (schema.sql)](#task-1-2-schema-implementation-schemasql)
    - [Task 1.3: Data Manipulation (queries.sql)](#task-1-3-data-manipulation-queriessql)
    - [Task 1.4: Advanced Querying](#task-1-4-advanced-querying)
    - [Task 1.5: Transactions and Isolation](#task-1-5-transactions-and-isolation)
2. [Part 2: Software System Design: Architecture and Scalability](#part-2-software-system-design-architecture-and-scalability)
    - [Task 2.1: Requirements and Architecture Choice](#task-2-1-requirements-and-architecture-choice)
    - [Task 2.2: High-Level Design & Scaling](#task-2-2-high-level-design--scaling)
    - [Task 2.3: Low-Level Design & SOLID Principles](#task-2-3-low-level-design--solid-principles)
    - [Task 2.4: Redundancy and Fault Tolerance](#task-2-4-redundancy-and-fault-tolerance)
3. [Part 3: Cybersecurity Principles and Cryptographic Protocols](#part-3-cybersecurity-principles-and-cryptographic-protocols)
    - [Task 3.1: CIA Triad and Attack Classification](#task-3-1-cia-triad-and-attack-classification)
    - [Task 3.2: Authentication & Authorization Design](#task-3-2-authentication--authorization-design)
    - [Task 3.3: RSA Cryptography Manual Computations](#task-3-3-rsa-cryptography-manual-computations)
    - [Task 3.4: Diffie-Hellman Key Exchange Manual Computations](#task-3-4-diffie-hellman-key-exchange-manual-computations)
    - [Task 3.5: TLS, Firewalls, and OS Hardening](#task-3-5-tls-firewalls-and-os-hardening)
4. [Part 4: Cloud Computing Models and Network Infrastructure](#part-4-cloud-computing-models-and-network-infrastructure)
    - [Task 4.1: OSI Model and Protocol Mapping](#task-4-1-osi-model-and-protocol-mapping)
    - [Task 4.2: Transport Protocols (TCP vs UDP)](#task-4-2-transport-protocols-tcp-vs-udp)
    - [Task 4.3: Cloud Deployment and Service Model Selection](#task-4-3-cloud-deployment-and-service-model-selection)
    - [Task 4.4: 5G Security Evolution & Architecture](#task-4-4-5g-security-evolution--architecture)
    - [Task 4.5: Network Operating System Choice](#task-4-5-network-operating-system-choice)

---

## Part 1: Relational Database Design and SQL Querying

### Task 1.1: Normalization Analysis
Given the unnormalized table:  
`StudentRecords(student_id, student_name, department, advisor_name, advisor_email, course_code, course_name, instructor_name, instructor_email, enrollment_year, marks_obtained)`  
*Composite Primary Key*: `{student_id, course_code}`

#### a. Partial and Transitive Dependencies
* **Partial Dependencies:** Non-prime attributes depend on a subset of the composite primary key.
  * `{student_id} -> student_name, department`
  * `{course_code} -> course_name, instructor_name, instructor_email`
* **Transitive Dependencies:** A non-prime attribute determines another non-prime attribute.
  * `advisor_name -> advisor_email` (via `student_id -> advisor_name -> advisor_email`)
  * `instructor_name -> instructor_email` (via `course_code -> instructor_name -> instructor_email`)

#### b. Boyce-Codd Normal Form (BCNF) Decomposition
To resolve anomalies, the relation is decomposed into 5 tables where every determinant is a superkey:
1. **Students** (`student_id` [PK], `student_name`, `department`, `advisor_name`)
2. **Advisors** (`advisor_name` [PK], `advisor_email`)
3. **Courses** (`course_code` [PK], `course_name`, `instructor_name`)
4. **Instructors** (`instructor_name` [PK], `instructor_email`)
5. **Enrollments** (`student_id` [FK], `course_code` [FK], `enrollment_year`, `marks_obtained`)  
   *Composite PK*: `{student_id, course_code}`

#### c. Data Integrity Verification
* **Entity Integrity:** Every table has an explicitly defined primary key that cannot be null.
* **Referential Integrity:** Foreign keys in `Enrollments` link to valid parent rows in `Students` and `Courses` with cascading rules.
* **Domain Integrity:** Strict column data types (e.g., `DECIMAL(5,2)` for grades) restrict entries to valid value ranges.
* **User-defined Integrity:** Custom logic (such as constraints checking that marks remain between 0 and 100) are fully enforceable.

---
