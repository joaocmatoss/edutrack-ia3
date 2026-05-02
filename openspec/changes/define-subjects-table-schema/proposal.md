## Why

The application needs a structured way to store and manage course subjects. Each subject should track its name, assigned teacher, contact hours, and relationship to the user who owns it. This enables proper course organization and data integrity within the edutrack system.

## What Changes

- Create a new `subjects` table in the database with the following structure:
  - `id`: Auto-incrementing primary key
  - `name`: Text field for the subject name
  - `teacher`: Text field for the teacher's name or identifier
  - `hours`: Integer field for the total contact hours
  - `user_id`: Foreign key referencing the users table to establish ownership

## Capabilities

### New Capabilities
- `subject-management`: Core capability to create, read, update, and delete subjects with proper database schema and validation

### Modified Capabilities
<!-- No existing capabilities are affected by this change -->

## Impact

- **Database**: New `subjects` table creation with specified schema and foreign key constraint to `users` table
- **Models**: Subjects entity model definition
- **API**: CRUD endpoints for subject management will be built based on this schema
- **Data Integrity**: Foreign key constraint ensures subjects are always associated with a valid user
