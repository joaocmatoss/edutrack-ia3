// Query all users records
query users verb=GET {
  api_group = "Application Data Persistence"

  input {
  }

  stack {
    db.query users {
      return = {type: "list"}
    } as $users
  }

  response = $users
}