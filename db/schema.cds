namespace ADMIN_MGMT;

using {managed} from '@sap/cds/common';

type StatusEnum : String(10) enum {
    ACTIVE;
    INACTIVE;
}

entity TB_USER_PROFILE : managed {
    key USER_PID                : String(20);
        USER_EMAIL_ID           : String(100);
        STATUS                  : StatusEnum; // Only ACTIVE or INACTIVE allowed
        SubAccountAccess        : Composition of many TB_SUBACCOUNT_ACCESS
                                      on SubAccountAccess.UserProfile = $self;
        SpaceAccess             : Composition of many TB_SPACE_ACCESS
                                      on SpaceAccess.UserProfile = $self;
        AssignedRoleCollections : Composition of many TB_ASSIGNED_ROLE_COLLECTIONS
                                      on AssignedRoleCollections.UserProfile = $self;
}
// Updated TB_USER_PROFILE entity with the STATUS field restricted to UserStatus.  // Only ACTIVE or INACTIVE allowed

// Child entity for Subaccounts.
entity TB_SUBACCOUNT_ACCESS : managed {
    key SUBACCOUNT_ID    : UUID;
        UserProfile      : Association to TB_USER_PROFILE;
        SUBACCOUNT_VALUE : String(100);
}

// Child entity for Space Access.
entity TB_SPACE_ACCESS : managed {
    key SPACE_ID    : UUID;
        UserProfile : Association to TB_USER_PROFILE;
        SPACE_VALUE : String(100);
}

// Child entity for Assigned Role Collections.
entity TB_ASSIGNED_ROLE_COLLECTIONS : managed {
    key ROLE_COLLECTION_ID    : UUID;
        UserProfile           : Association to TB_USER_PROFILE;
        ROLE_COLLECTION_VALUE : String(100);
}
