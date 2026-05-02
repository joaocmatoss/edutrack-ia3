## Context

The edutrack system requires persistent storage of subject information organized by users. Currently, there is no formal subjects table structure. The database uses a user-based organization model where each user owns resources including courses and their subjects.

## Goals / Non-Goals

**Goals:**
- Define a robust schema for the `subjects` table with appropriate data types and constraints
- Establish proper foreign key relationship to the `users` table to maintain referential integrity
- Enable efficient querying and filtering of subjects by user
- Provide a foundation for subject-related CRUD operations

**Non-Goals:**
- Authentication and authorization logic (handled separately)
- API endpoint implementation (covered in tasks phase)
- Subject-teacher relationship details beyond name storage
- Grade/assessment data (separate capability)

## Decisions

**1. Primary Key Strategy**
- Decision: Use auto-incrementing integer `id` as primary key
- Rationale: Ensures unique identification, efficient indexing, and simplifies API design
- Alternatives considered: UUID (overkill for internal references), composite keys (unnecessary complexity)

**2. Field Data Types**
- `id`: BIGINT/INT AUTO_INCREMENT PRIMARY KEY (auto-incrementing identifier)
- `name`: VARCHAR(255) NOT NULL (required field, text constraint for reasonable length)
- `teacher`: VARCHAR(255) NOT NULL (required field, text for teacher name or identifier)
- `hours`: INT NOT NULL CHECK (hours >= 0) (non-negative integer for contact hours)
- `user_id`: BIGINT NOT NULL FOREIGN KEY → users.id (establishes ownership)

**3. Foreign Key Constraint**
- Decision: `user_id` as NOT NULL foreign key with CASCADE DELETE
- Rationale: Ensures data integrity, prevents orphaned subject records, simplifies cleanup when users are deleted
- Cascade strategy: When a user is deleted, all their subjects are automatically removed

**4. Timestamps**
- Decision: Include `created_at` and `updated_at` timestamps (standard practice)
- Rationale: Track creation and modification history for audit trails and sorting/filtering operations

## Risks / Trade-offs

**[Risk] CASCADE DELETE removes all subjects when user is deleted**
- Mitigation: Implement soft deletes or review/approval process before user deletion. Consider alerting admin of data loss.

**[Risk] teacher field is text, not a foreign key relationship**
- Mitigation: Acceptable for MVP. Can be refactored to foreign key if teacher management becomes a feature. Document as "future enhancement".

**[Risk] Limited validation on field lengths**
- Mitigation: Enforce VARCHAR limits and NOT NULL constraints at database level. Additional validation handled in application layer.

## Migration Plan

1. Create migration script to generate the `subjects` table with specified schema
2. Add unique constraint on user_id + name combination if desired (optional, for this iteration omitted)
3. Verify foreign key constraint is active
4. Run migration in development environment for testing
5. Deploy to staging for integration testing
6. Production deployment with rollback capability

## Open Questions

- Should `user_id` + `name` be unique (prevent duplicate subject names per user)?
- What is the maximum expected value for hours field? INT should suffice but confirm requirements
- Should we include soft deletes instead of cascade delete?
