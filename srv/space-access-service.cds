using { cuid } from '@sap/cds/common';

service SpaceAccessService @(path: '/Sapce_srv') {

  type RoleAssignmentInput : {
    userGUID  : String;
    spaceGUID : String;
  }

  type RoleAssignmentResult : {
    message : String;
  }

  action AssignSpaceDeveloper(data: RoleAssignmentInput) returns RoleAssignmentResult;
  action AssignSpaceAuditor(data: RoleAssignmentInput) returns RoleAssignmentResult;
  action AssignSpaceManager(data: RoleAssignmentInput) returns RoleAssignmentResult;

}
