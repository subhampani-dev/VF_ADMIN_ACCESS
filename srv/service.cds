using {ADMIN_MGMT as Tables} from '../db/schema';

service ADM_service @(path: '/ADM_srv') @(requires: ['authenticated-user']) {
    entity TB_USER_PROFILE as projection on Tables.TB_USER_PROFILE;
}
