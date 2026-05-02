## ADDED Requirements

### Requirement: Subject table schema definition
The system SHALL persist subject data in a `subjects` table with the following structure:
- `id` (BIGINT, AUTO_INCREMENT, PRIMARY KEY): Unique identifier for each subject
- `name` (VARCHAR(255), NOT NULL): The name of the subject
- `teacher` (VARCHAR(255), NOT NULL): Name or identifier of the teacher responsible for the subject
- `hours` (INT, NOT NULL, CHECK hours >= 0): Total contact hours for the subject
- `user_id` (BIGINT, NOT NULL, FOREIGN KEY → users.id): References the user who owns this subject
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP): Record creation timestamp
- `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP): Record modification timestamp

#### Scenario: Table creation with valid schema
- **WHEN** the database migration runs
- **THEN** the `subjects` table is created with all specified columns and constraints
- **AND** the `user_id` foreign key constraint is active with CASCADE DELETE behavior

#### Scenario: Subject data persistence
- **WHEN** a subject record is inserted with valid data
- **THEN** the record is stored successfully with auto-generated id and timestamps

### Requirement: Subject ownership through user relationship
The system SHALL enforce that every subject belongs to exactly one user through a foreign key constraint.

#### Scenario: Foreign key constraint enforced
- **WHEN** an attempt is made to insert a subject with non-existent user_id
- **THEN** the database rejects the operation with a foreign key violation error

#### Scenario: Cascade delete on user removal
- **WHEN** a user is deleted from the system
- **THEN** all subjects owned by that user are automatically deleted

### Requirement: Subject field validation
The system SHALL validate subject fields according to the following rules:
- `name` and `teacher`: Required text fields, maximum 255 characters each
- `hours`: Required non-negative integer value
- `user_id`: Required reference to existing user

#### Scenario: Valid subject creation
- **WHEN** creating a subject with valid name, teacher, hours, and user_id
- **THEN** the subject is successfully persisted

#### Scenario: Hours cannot be negative
- **WHEN** attempting to create a subject with negative hours value
- **THEN** the database constraint rejects the operation

#### Scenario: Required fields cannot be empty
- **WHEN** attempting to create a subject with missing name, teacher, or user_id
- **THEN** the database NOT NULL constraint prevents the operation

### Requirement: Timestamp tracking
The system SHALL automatically maintain `created_at` and `updated_at` timestamps for audit and sorting purposes.

#### Scenario: Automatic timestamp on creation
- **WHEN** a subject record is created
- **THEN** `created_at` is set to the current timestamp
- **AND** `updated_at` is set to the current timestamp

#### Scenario: Updated timestamp on modification
- **WHEN** an existing subject record is updated
- **THEN** the `updated_at` field is automatically updated to the current timestamp
- **AND** `created_at` remains unchanged
