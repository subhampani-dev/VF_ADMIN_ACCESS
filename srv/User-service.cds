service UserManagementService {

  // Custom type for email input
  type EmailInput : {
    value : String;
    type  : String;
  }

  // Custom type for user output
  type UserOutput : {
    id        : String;
    userName  : String;
    emails    : many EmailInput;
    roles     : many String;
  }

  // Action to create a new user
  action CreateUser(
    userName : String,
    emails   : many EmailInput,
    roles    : many String
  ) returns String;

  // Function to get all users
  function GetUsers() returns many UserOutput;

  // Action to update a user
  action UpdateUser(
    ID       : String,
    userName : String,
    emails   : many EmailInput,
    roles    : many String
  ) returns String;

  // Action to delete a user
  action DeleteUser(ID : String) returns String;

}