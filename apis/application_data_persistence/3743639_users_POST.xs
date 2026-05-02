// Add users record
query users verb=POST {
  api_group = "Application Data Persistence"

  input {
    dblink {
      table = "users"
    }
  }

  stack {
    db.add users {
      data = {created_at: "now"}
    } as $users
  }

  response = $users
}