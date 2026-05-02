/**
 * subjects.xs
 * 
 * XanoScript module for Subject operations
 * Provides helper functions for managing subject records in the subjects table
 * 
 * Dependencies:
 *   - users table (for foreign key validation)
 *   - subjects table (created by 001_create_subjects_table migration)
 */

// Validate subject data before insertion/update
func validateSubject(data) {
  var errors = [];
  
  // Validate name
  if (empty(data.name)) {
    errors.push("name is required");
  } else if (length(data.name) > 255) {
    errors.push("name must be 255 characters or less");
  }
  
  // Validate teacher
  if (empty(data.teacher)) {
    errors.push("teacher is required");
  } else if (length(data.teacher) > 255) {
    errors.push("teacher must be 255 characters or less");
  }
  
  // Validate hours
  if (is_null(data.hours)) {
    errors.push("hours is required");
  } else if (!is_number(data.hours)) {
    errors.push("hours must be a number");
  } else if (data.hours < 0) {
    errors.push("hours cannot be negative");
  }
  
  // Validate user_id
  if (is_null(data.user_id)) {
    errors.push("user_id is required");
  } else if (!is_number(data.user_id)) {
    errors.push("user_id must be a number");
  }
  
  if (length(errors) > 0) {
    return {
      valid: false,
      errors: errors
    };
  }
  
  return {
    valid: true,
    errors: []
  };
}

// Create a new subject record
func createSubject(name, teacher, hours, user_id) {
  var subjectData = {
    name: name,
    teacher: teacher,
    hours: hours,
    user_id: user_id
  };
  
  var validation = validateSubject(subjectData);
  if (!validation.valid) {
    return {
      success: false,
      error: "Validation failed",
      details: validation.errors
    };
  }
  
  // Verify user exists
  var userExists = db("users").where({id: user_id}).count() > 0;
  if (!userExists) {
    return {
      success: false,
      error: "User not found",
      user_id: user_id
    };
  }
  
  // Insert subject record
  var result = db("subjects").insert({
    name: name,
    teacher: teacher,
    hours: hours,
    user_id: user_id,
    created_at: now(),
    updated_at: now()
  });
  
  return {
    success: true,
    subject_id: result.id,
    created_at: result.created_at
  };
}

// Retrieve subject by ID
func getSubjectById(id) {
  var subject = db("subjects").where({id: id}).limit(1).first();
  
  if (is_null(subject)) {
    return {
      success: false,
      error: "Subject not found",
      id: id
    };
  }
  
  return {
    success: true,
    subject: subject
  };
}

// Retrieve all subjects for a user
func getSubjectsByUserId(user_id) {
  var subjects = db("subjects")
    .where({user_id: user_id})
    .order({created_at: "desc"})
    .get();
  
  return {
    success: true,
    user_id: user_id,
    count: length(subjects),
    subjects: subjects
  };
}

// Update an existing subject
func updateSubject(id, updates) {
  var subject = db("subjects").where({id: id}).limit(1).first();
  
  if (is_null(subject)) {
    return {
      success: false,
      error: "Subject not found",
      id: id
    };
  }
  
  // Merge updates with existing data for validation
  var updatedData = object_merge(subject, updates);
  var validation = validateSubject(updatedData);
  if (!validation.valid) {
    return {
      success: false,
      error: "Validation failed",
      details: validation.errors
    };
  }
  
  // Verify user_id if being updated
  if (contains_key(updates, "user_id")) {
    var userExists = db("users").where({id: updates.user_id}).count() > 0;
    if (!userExists) {
      return {
        success: false,
        error: "User not found",
        user_id: updates.user_id
      };
    }
  }
  
  // Update subject record
  updates.updated_at = now();
  var result = db("subjects").where({id: id}).update(updates);
  
  return {
    success: true,
    subject_id: id,
    updated_at: updates.updated_at
  };
}

// Delete a subject
func deleteSubject(id) {
  var subject = db("subjects").where({id: id}).limit(1).first();
  
  if (is_null(subject)) {
    return {
      success: false,
      error: "Subject not found",
      id: id
    };
  }
  
  db("subjects").where({id: id}).delete();
  
  return {
    success: true,
    deleted_id: id
  };
}

// List subjects with pagination and filtering
func listSubjects(user_id, page = 1, limit = 10) {
  var offset = (page - 1) * limit;
  
  var query = db("subjects").where({user_id: user_id});
  var totalCount = query.count();
  
  var subjects = query
    .order({created_at: "desc"})
    .limit(limit)
    .offset(offset)
    .get();
  
  var totalPages = ceil(totalCount / limit);
  
  return {
    success: true,
    user_id: user_id,
    page: page,
    limit: limit,
    totalCount: totalCount,
    totalPages: totalPages,
    subjects: subjects
  };
}