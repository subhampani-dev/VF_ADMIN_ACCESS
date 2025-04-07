service SpaceUserLookupService @(path: '/Lookup_srv'){

  type UserLookupInput : {
    userName : String;   // email ID or user name (e.g., john.doe@example.com)
    origin   : String;   // e.g., "sap.default" or "ldap"
  }

  type UserLookupResult : {
    guid     : String;
    userName : String;
    origin   : String;
  }

  action GetUserGUIDByEmail(data: UserLookupInput) returns UserLookupResult;
}