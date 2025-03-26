using {ADMIN_MGMT as Tables} from '../db/schema';

service ADM_service @(path: '/ADM_srv') @(requires: ['authenticated-user']) {
    entity TB_USER_PROFILE as projection on Tables.TB_USER_PROFILE;

    @readonly
    entity Subaccounts {
        key subaccountId : String;
            name         : String;
            region       : String;
    }

    @readonly
    entity Spaces {
        key spaceId      : String;
            name         : String;
            subaccountId : String;
    }

    @requires: 'authenticated-user'
    function getSubaccounts()                 returns array of Subaccounts;

    @requires: 'authenticated-user'
    function getSpaces(subaccountId : String) returns array of Spaces;
}
