/**
 * api_endpoints.subjects.xs
 * 
 * REST API endpoint definitions for Subjects resource
 * 
 * Endpoints:
 *   POST   /api/subjects
 *   GET    /api/subjects
 *   GET    /api/subjects/:id
 *   PUT    /api/subjects/:id
 *   DELETE /api/subjects/:id
 */

// POST /api/subjects
// Create a new subject
endpoint POST /api/subjects {
  auth_required: true,
  
  body: {
    name: "string (required, max 255)",
    teacher: "string (required, max 255)",
    hours: "number (required, >= 0)",
    user_id: "number (required, must exist in users table)"
  },
  
  response: {
    success: "boolean",
    subject_id: "number (on success)",
    error: "string (on failure)",
    details: "array (validation errors)"
  },
  
  handler() {
    return createSubject(
      body.name,
      body.teacher,
      body.hours,
      body.user_id
    );
  }
}

// GET /api/subjects/:user_id
// Get all subjects for a user
endpoint GET /api/subjects/:user_id {
  auth_required: true,
  
  params: {
    user_id: "number (required)",
    page: "number (optional, default 1)",
    limit: "number (optional, default 10)"
  },
  
  response: {
    success: "boolean",
    user_id: "number",
    page: "number",
    limit: "number",
    totalCount: "number",
    totalPages: "number",
    subjects: "array"
  },
  
  handler() {
    var page = query.page || 1;
    var limit = query.limit || 10;
    
    return listSubjects(params.user_id, page, limit);
  }
}

// GET /api/subjects/:id/detail
// Get a specific subject by ID
endpoint GET /api/subjects/:id/detail {
  auth_required: true,
  
  params: {
    id: "number (required)"
  },
  
  response: {
    success: "boolean",
    subject: "object (on success)",
    error: "string (on failure)"
  },
  
  handler() {
    return getSubjectById(params.id);
  }
}

// PUT /api/subjects/:id
// Update an existing subject
endpoint PUT /api/subjects/:id {
  auth_required: true,
  
  params: {
    id: "number (required)"
  },
  
  body: {
    name: "string (optional, max 255)",
    teacher: "string (optional, max 255)",
    hours: "number (optional, >= 0)",
    user_id: "number (optional, must exist in users table)"
  },
  
  response: {
    success: "boolean",
    subject_id: "number (on success)",
    error: "string (on failure)",
    details: "array (validation errors)"
  },
  
  handler() {
    var updates = {};
    
    if (contains_key(body, "name")) {
      updates.name = body.name;
    }
    if (contains_key(body, "teacher")) {
      updates.teacher = body.teacher;
    }
    if (contains_key(body, "hours")) {
      updates.hours = body.hours;
    }
    if (contains_key(body, "user_id")) {
      updates.user_id = body.user_id;
    }
    
    return updateSubject(params.id, updates);
  }
}

// DELETE /api/subjects/:id
// Delete a subject
endpoint DELETE /api/subjects/:id {
  auth_required: true,
  
  params: {
    id: "number (required)"
  },
  
  response: {
    success: "boolean",
    deleted_id: "number (on success)",
    error: "string (on failure)"
  },
  
  handler() {
    return deleteSubject(params.id);
  }
}