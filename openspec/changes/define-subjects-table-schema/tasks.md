## 1. Create Subjects Table

- [x] 1.1 Create database migration file for subjects table
- [x] 1.2 Add id column (BIGINT AUTO_INCREMENT PRIMARY KEY)
- [x] 1.3 Add name column (VARCHAR(255) NOT NULL)
- [x] 1.4 Add teacher column (VARCHAR(255) NOT NULL)
- [x] 1.5 Add hours column (INT NOT NULL with CHECK hours >= 0)
- [x] 1.6 Add user_id column (BIGINT NOT NULL FOREIGN KEY → users.id CASCADE DELETE)
- [x] 1.7 Add created_at and updated_at timestamp columns with defaults
- [x] 1.8 Run migration and verify table creation

## 2. XanoScript Helper Functions

- [x] 2.1 Create XanoScript functions module (subjects.xs)
- [x] 2.2 Implement validateSubject() with field validation
- [x] 2.3 Implement createSubject() with user validation
- [x] 2.4 Implement getSubjectById() retrieval function
- [x] 2.5 Implement getSubjectsByUserId() with ordering
- [x] 2.6 Implement updateSubject() with validation
- [x] 2.7 Implement deleteSubject() function
- [x] 2.8 Implement listSubjects() with pagination

## 3. REST API Endpoints

- [x] 3.1 Define POST /api/subjects endpoint
- [x] 3.2 Define GET /api/subjects/:user_id endpoint with pagination
- [x] 3.3 Define GET /api/subjects/:id/detail endpoint
- [x] 3.4 Define PUT /api/subjects/:id endpoint
- [x] 3.5 Define DELETE /api/subjects/:id endpoint
- [x] 3.6 All endpoints configured with auth_required: true
