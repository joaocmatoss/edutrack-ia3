/**
 * Migration: 001_create_subjects_table
 * Description: Create subjects table with schema as defined in define-subjects-table-schema change
 * Date: 2026-04-26
 * Platform: Xano
 * 
 * This migration defines the structure for the subjects table in Xano's database.
 * Run this in Xano Database Manager or via API call to initialize the table.
 */

// Table Definition: subjects
// Execute this configuration in Xano Database Manager

TABLE: subjects {
  // Primary identifier
  field: id {
    type: "number",
    required: true,
    primaryKey: true,
    autoIncrement: true,
    description: "Unique identifier for each subject"
  },
  
  // Subject information
  field: name {
    type: "text",
    required: true,
    maxLength: 255,
    description: "The name of the subject"
  },
  
  field: teacher {
    type: "text",
    required: true,
    maxLength: 255,
    description: "Name or identifier of the teacher responsible for the subject"
  },
  
  field: hours {
    type: "number",
    required: true,
    validation: "hours >= 0",
    description: "Total contact hours for the subject"
  },
  
  // Foreign key relationship
  field: user_id {
    type: "number",
    required: true,
    foreignKey: "users.id",
    onDelete: "cascade",
    description: "References the user who owns this subject"
  },
  
  // Timestamps
  field: created_at {
    type: "datetime",
    required: true,
    default: "now()",
    description: "Record creation timestamp"
  },
  
  field: updated_at {
    type: "datetime",
    required: true,
    default: "now()",
    onUpdate: "now()",
    description: "Record modification timestamp"
  },
  
  // Indexes
  index: idx_user_id {
    fields: ["user_id"],
    unique: false,
    description: "Index on user_id for efficient filtering"
  },
  
  index: idx_created_at {
    fields: ["created_at"],
    unique: false,
    description: "Index on created_at for sorting/filtering"
  }
}
