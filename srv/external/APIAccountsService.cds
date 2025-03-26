/* checksum : aaad57a0084a0c73fa9c4ed8e9f5dd40 */
@Capabilities.BatchSupported : false
@Capabilities.KeyAsSegmentSupported : true
@Core.Description : 'Accounts Service'
@Core.SchemaVersion : '1.0'
@Core.LongDescription : ```
The Accounts service provides REST APIs that are responsible for the management of global accounts, and the creation and management of directories, subaccounts, and their custom properties/tags. 
Global accounts represent a business entity and contain contract information, including customer details and purchased entitlements. The global account is the context for billing each customer. 
Use the subaccount APIs to structure your global account according to your organization's and project's requirements regarding members, authorizations, and quotas. This service also provides you with APIs for creating and managing directories. While the use of directories is optional, they allow you to further organize and manage your subaccounts according to your specific technical and business needs. The service also lets you manage the custom properties/tags that you associate with your directories and subaccounts.

See also:
* [Authorization](https://help.sap.com/viewer/65de2977205c403bbc107264b8eccf4b/latest/en-US/3670474a58c24ac2b082e76cbbd9dc19.html)
* [Rate Limiting](https://help.sap.com/viewer/65de2977205c403bbc107264b8eccf4b/latest/en-US/77b217b3f57a45b987eb7fbc3305ce1e.html)
* [Error Response Format](https://help.sap.com/viewer/65de2977205c403bbc107264b8eccf4b/latest/en-US/77fef2fb104b4b1795e2e6cee790e8b8.html)
* [Asynchronous Jobs](https://help.sap.com/viewer/65de2977205c403bbc107264b8eccf4b/latest/en-US/0a0a6ab0ad114d72a6611c1c6b21683e.html)
```
service Accounts.Service {};

@Common.Label : 'Directory Operations'
@Core.Description : 'Create a directory'
@Core.LongDescription : ```
Directories allow you to organize and manage your subaccounts according to your technical and business needs.
A directory can contain one or more subaccounts and directories. The maximum number of directory levels allowed in a global account is 5.
Using directories to group subaccounts is optional.
If you have directories in your account model, you can still create subaccounts directly under your global account.

Required scope: \$XSAPPNAME.global-account.account-directory.create
```
@openapi.path : '/accounts/v1/directories'
action Accounts.Service.accounts_v1_directories_post(
  @description : `The unique ID of the directory's parent entity.
 You can create the directory directly under a global account or another directory.`
  @openapi.in : 'query'
  parentGUID : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.CreateDirectoryRequestPayload
) returns Accounts.Service_types.DirectoryResponseObject;

@Common.Label : 'Directory Operations'
@Core.Description : 'Delete a directory'
@Core.LongDescription : 'Delete the directory, including its subdirectories, subaccounts, and their content.<br/><br/>Required scope: $XSAPPNAME.global-account.account-directory.delete'
@openapi.method : 'DELETE'
@openapi.path : '/accounts/v1/directories/{directoryGUID}'
action Accounts.Service.accounts_v1_directories__delete(
  @description : 'The GUID of the directory to delete.'
  @openapi.in : 'path'
  directoryGUID : String,
  @description : 'Specifies whether to delete the directory and all its content, including subdirectories, subaccounts, and data contained within (default is false). Content refers to any entity or data, such as applications, service instances, spaces, active subscriptions, brokers, platform, and members, depending on the type of subaccount (Neo or multi-environment).  When set to false, the request fails if the directory contains subdirectories and subaccounts, even if they are empty. When set to true, all content in the directory is permanently deleted. The deletion may take a while depending on the amount of content in your subaccounts.'
  @openapi.in : 'query'
  forceDelete : Boolean
) returns Accounts.Service_types.DirectoryResponseObject;

@Common.Label : 'Directory Operations'
@Core.Description : 'Get a directory'
@Core.LongDescription : 'Get details for a specified directory.<br/><br/>Required scope: $XSAPPNAME.global-account.account-directory.read'
@openapi.path : '/accounts/v1/directories/{directoryGUID}'
function Accounts.Service.accounts_v1_directories_(
  @description : 'The GUID of the directory for which to get details.'
  @openapi.in : 'path'
  directoryGUID : String,
  @description : 'Whether to get the contents of the directory, for example the subaccounts it contains.'
  @openapi.in : 'query'
  expand : Boolean
) returns Accounts.Service_types.DirectoryResponseObject;

@Common.Label : 'Directory Operations'
@Core.Description : 'Update a directory'
@Core.LongDescription : `Update the properties of a directory.
You can update its display name, description, and assigned labels.<br/><br/>Required scope: \$XSAPPNAME.account-directory.update`
@openapi.method : 'PATCH'
@openapi.path : '/accounts/v1/directories/{directoryGUID}'
action Accounts.Service.accounts_v1_directories__patch(
  @description : 'The GUID of the directory to update.'
  @openapi.in : 'path'
  directoryGUID : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.UpdateDirectoryRequestPayload
) returns Accounts.Service_types.DirectoryResponseObject;

@Common.Label : 'Directory Operations'
@Core.Description : 'Add or remove features for a directory'
@Core.LongDescription : ```
Global account admins can enable additional features in a directory or remove features that are already enabled.

By default, all directories provide the following basic features: (1) group and filter subaccounts, (2) monitor usage and costs, and (3) set custom properties and tags. Optionally, you can allow a directory to also manage its own entitlements and its user authorizations.

All existing subaccounts and subdirectories in the directory implicitly inherit the capabilities of the enabled features in this directory.

NOTE: The user authorizations management feature must be applied in combination with the entitlement management feature. In other words, if the directory has both entitlement and user authorization management enable, you cannot disable just the entitlement management feature without also disabling user authorization management. Likewise, if a directory has only the default features enabled, you cannot enable user authorization management without also enabling entitlement management.

NOTE: Your multi-level account hierarchy can have more than one directory enabled with user authorization and/or entitlement management; however, only one directory in any directory path can have these features enabled. In other words, other directories above or below this directory in the same path can only have the default features specified. If you are not sure which features to enable, we recommend that you set only the default features, and then add features later on as they are needed.

Required scope: \$XSAPPNAME.account-directory.update
```
@openapi.method : 'PATCH'
@openapi.path : '/accounts/v1/directories/{directoryGUID}/changeDirectoryFeatures'
action Accounts.Service.accounts_v1_directories__changeDirectoryFeatures_patch(
  @description : 'The GUID of the directory to update directory features.'
  @openapi.in : 'path'
  directoryGUID : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.UpdateDirectoryTypeRequestPayload
) returns Accounts.Service_types.DirectoryResponseObject;

@Common.Label : 'Directory Operations'
@Core.Description : 'Get custom properties for a directory (deprecated)'
@Core.LongDescription : ```
Get all the custom properties that are assigned as key-value pairs to a given directory.

NOTE: This API is deprecated. Custom properties are now called labels. The "customProperties" field supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. This API returns only the first value of any label key that has multiple values assigned to it. Use instead: GET /accounts/v1/directories/{directoryGUID}/labels

Required scope: \$XSAPPNAME.global-account.account-directory.read
```
@openapi.path : '/accounts/v1/directories/{directoryGUID}/customProperties'
function Accounts.Service.accounts_v1_directories__customProperties(
  @description : 'The unique ID of the directory for which to get custom properties.'
  @openapi.in : 'path'
  directoryGUID : String
) returns Accounts.Service_types.ResponseCollection;

@Common.Label : 'Directory Operations'
@Core.Description : 'Delete all labels from a directory'
@Core.LongDescription : ```
Remove all user-defined labels that are assigned to a given directory.

To remove specific labels, use instead: PUT /accounts/v1/directories/{directoryGUID}/labels

Required scope: \$XSAPPNAME.global-account.account-directory.update
```
@openapi.method : 'DELETE'
@openapi.path : '/accounts/v1/directories/{directoryGUID}/labels'
action Accounts.Service.accounts_v1_directories__labels_delete(
  @description : 'The GUID of the directory'
  @openapi.in : 'path'
  directoryGUID : String
) returns Accounts.Service_types.LabelsResponseObject;

@Common.Label : 'Directory Operations'
@Core.Description : 'Get labels for a directory'
@Core.LongDescription : `Get all the user-defined labels, that are assigned as key-value pairs to a given directory. 

Required scope: \$XSAPPNAME.global-account.account-directory.read`
@openapi.path : '/accounts/v1/directories/{directoryGUID}/labels'
function Accounts.Service.accounts_v1_directories__labels(
  @description : 'The GUID of the directory.'
  @openapi.in : 'path'
  directoryGUID : String
) returns Accounts.Service_types.LabelsResponseObject;

@Common.Label : 'Directory Operations'
@Core.Description : 'Assign labels to a directory'
@Core.LongDescription : `Assign user-defined labels to a given directory. Labels are specified as key-value pairs.

Required scope: \$XSAPPNAME.global-account.account-directory.update`
@openapi.method : 'PUT'
@openapi.path : '/accounts/v1/directories/{directoryGUID}/labels'
action Accounts.Service.accounts_v1_directories__labels_put(
  @description : 'The GUID of the directory.'
  @openapi.in : 'path'
  directoryGUID : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.LabelAssignmentRequestPayload
) returns Accounts.Service_types.LabelsResponseObject;

@Common.Label : 'Directory Operations'
@Core.Description : 'Delete directory settings'
@Core.LongDescription : 'Delete directory settings for a specified directory.<br/><br/>Required scope: $XSAPPNAME.account-directory.update'
@openapi.method : 'DELETE'
@openapi.path : '/accounts/v1/directories/{directoryGUID}/settings'
action Accounts.Service.accounts_v1_directories__settings_delete(
  @description : 'The GUID of the directory.'
  @openapi.in : 'path'
  directoryGUID : String,
  @description : 'Keys for the property. Limited to 255 characters.'
  @openapi.in : 'query'
  @openapi.required : true
  keys : many String
) returns Accounts.Service_types.DataResponseObject;

@Common.Label : 'Directory Operations'
@Core.Description : 'Get directory settings'
@Core.LongDescription : 'Get directory settings for a specified directory.<br/><br/>Required scope: $XSAPPNAME.account-directory.read'
@openapi.path : '/accounts/v1/directories/{directoryGUID}/settings'
function Accounts.Service.accounts_v1_directories__settings(
  @description : 'The GUID of the directory.'
  @openapi.in : 'path'
  directoryGUID : String,
  @description : 'Keys for the property. Limited to 255 characters.'
  @openapi.in : 'query'
  keys : many String
) returns Accounts.Service_types.DataResponseObject;

@Common.Label : 'Directory Operations'
@Core.Description : 'Create or update directory settings'
@Core.LongDescription : 'Create or update directory settings for a specified directory.<br/><br/>Required scope: $XSAPPNAME.account-directory.update'
@openapi.method : 'PUT'
@openapi.path : '/accounts/v1/directories/{directoryGUID}/settings'
action Accounts.Service.accounts_v1_directories__settings_put(
  @description : 'The GUID of the directory.'
  @openapi.in : 'path'
  directoryGUID : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.EntitySettingsRequestPayload
) returns Accounts.Service_types.DataResponseObject;

@Common.Label : 'Global Account Operations'
@Core.Description : 'Get a global account'
@Core.LongDescription : 'Get information for a specified global account.<br/><br/>Required scopes: $XSAPPNAME.global-account.read'
@openapi.path : '/accounts/v1/globalAccount'
function Accounts.Service.accounts_v1_globalAccount(
  @description : 'If true, returns the structure of the global account including all its children, such as subaccounts and directories, in the account model. The structure content may vary from user to user and depends on users’ authorizations.'
  @openapi.in : 'query'
  expand : Boolean
) returns Accounts.Service_types.GlobalAccountResponseObject;

@Common.Label : 'Global Account Operations'
@Core.Description : 'Update a global account'
@Core.LongDescription : 'Update the display name and/or description of the global account.<br/><br/>Required scope: $XSAPPNAME.global-account.update'
@openapi.method : 'PATCH'
@openapi.path : '/accounts/v1/globalAccount'
action Accounts.Service.accounts_v1_globalAccount_patch(
  @openapi.in : 'body'
  body : Accounts.Service_types.UpdateGlobalAccountRequestPayload
) returns Accounts.Service_types.GlobalAccountResponseObject;

@Common.Label : 'Global Account Operations'
@Core.Description : 'Get custom properties for a global account (deprecated)'
@Core.LongDescription : ```
Get all the custom properties that are assigned as key-value pairs to a given global account.

NOTE: This API is deprecated. Custom properties are now called labels. The "customProperties" field supports only single values per key and is now replaced by the "labels" field, which is string array that supports multiple values per key. This API returns only the first value of any label key that has multiple values assigned to it. Use instead: GET /accounts/v1/globalAccount/labels

Required scope: \$XSAPPNAME.global-account.read

```
@openapi.path : '/accounts/v1/globalAccount/customProperties'
function Accounts.Service.accounts_v1_globalAccount_customProperties() returns Accounts.Service_types.ResponseCollection;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Get all subaccounts'
@Core.LongDescription : `Get information for all subaccounts in the global account and those under directories, if they exist.<br/><br/>Required scopes:
* When derivedAuthorizations is empty, then \$XSAPPNAME.global-account.subaccount.read
* When derivedAuthorizations=any, then requires any valid token from XSUAA.`
@openapi.path : '/accounts/v1/subaccounts'
function Accounts.Service.accounts_v1_subaccounts(
  @description : 'Returns only the subaccounts in a given directory. Provide the unique ID of the directory.'
  @openapi.in : 'query'
  directoryGUID : String,
  @assert.range : true
  @description : `The range of authorizations for which to return information.
* any: Returns all global accounts for which the user has authorizations on any of the accounts' entities, such as its subaccounts (for example, user is a subaccount admin) or spaces (for example, user is a Cloud Foundry space manager).
* (empty value): Returns all subaccounts for which the user has explicit authorization (\$XSAPPNAME.global-account.subaccount.read) on the global account or directory.`
  @openapi.in : 'query'
  derivedAuthorizations : String enum {
    ![any];
    saadmin;
  },
  @description : 'Get all existing subaccounts that match or don''t match one or more user-defined labels. Specify the key-value pair of the label using either the equals (=) or not equals operator (!=). Keys, values, and operator must be URL encoded. Use the AND operand to include more than one label in the query. You can specify only a single value per key. Parameter does not support label keys or values that include space, =, or ! characters. Usage example where the keys "my-key-1" and "my-key-2" have the values "my-value-1" and "my-value-2" , respectively: my-key-1%3Dmy-value-1%20AND%20my-key-2%3Dmy-value-2'
  @openapi.in : 'query'
  labelSelector : String
) returns Accounts.Service_types.ResponseCollection;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Create a subaccount'
@Core.LongDescription : 'Create a subaccount in a global account or directory.<br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.create'
@openapi.path : '/accounts/v1/subaccounts'
action Accounts.Service.accounts_v1_subaccounts_post(
  @description : 'To prevent errors, special characters must be URL encoded. For example, the e-mail "name+dev_user@example.com" must be encoded as: name%2Bdev_user@example.com. You can add users only from the same user base as you (example: sap.default or custom identity provider).'
  @openapi.in : 'query'
  subaccountAdmin : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.CreateSubaccountRequestPayload
) returns Accounts.Service_types.SubaccountResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Clone a Neo subaccount'
@Core.LongDescription : 'Create a clone of an existing Neo-based subaccount in a given global account.<br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.create'
@openapi.path : '/accounts/v1/subaccounts/clone/{sourceSubaccountGUID}'
action Accounts.Service.accounts_v1_subaccounts_clone__post(
  @description : 'The GUID of the Neo subaccount to clone.'
  @openapi.in : 'path'
  sourceSubaccountGUID : String,
  @description : 'To prevent errors, special characters must be URL encoded. For example, the e-mail "name+dev_user@example.com" must be encoded as: name%2Bdev_user@example.com. You can add users only from the same user base as you (example: sap.default or custom identity provider).'
  @openapi.in : 'query'
  subaccountAdmin : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.CloneNeoSubaccountRequestPayload
) returns Accounts.Service_types.SubaccountResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Batch move subaccounts'
@Core.LongDescription : ```
Move several subaccounts at once to a different directory or out of a directory to the global account.<br/><br/>Required scopes for source directory:
\$XSAPPNAME.global-account.subaccount.read,
\$XSAPPNAME.global-account.subaccount.delete.


Required scopes for target directory:
\$XSAPPNAME.global-account.subaccount.create
```
@openapi.path : '/accounts/v1/subaccounts/move'
action Accounts.Service.accounts_v1_subaccounts_move_post(
  @openapi.in : 'body'
  body : Accounts.Service_types.MoveSubaccountsRequestPayloadCollection
) returns Accounts.Service_types.ResponseCollection;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Delete a subaccount '
@Core.LongDescription : 'Delete the subaccount and its content.</br><br/>Required scope: $XSAPPNAME.global-account.subaccount.delete'
@openapi.method : 'DELETE'
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}'
action Accounts.Service.accounts_v1_subaccounts__delete(
  @description : 'The GUID of the subaccount for which to get details.'
  @openapi.in : 'path'
  subaccountGUID : String,
  @description : 'Specifies whether to delete the subaccount if it contains content (default is false). Content refers to any entity or data, such as applications, service instances, spaces, active subscriptions, brokers, platform, and members, depending on the type of subaccount (Neo or multi-environment). When set to false, the request fails if the subaccount is not empty. When set to true, all content in the subaccount is permanently deleted. Depending on the amount of content in the subaccount, it may take several hours for the subaccount to be deleted. After the subaccount is deleted, it may take a few more days for some related services to be deleted. You won''t be charged for any continued usage of these services in the subaccount during the deletion cleanup.'
  @openapi.in : 'query'
  forceDelete : Boolean
) returns Accounts.Service_types.SubaccountResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Get a subaccount'
@Core.LongDescription : 'Get information for a specified subaccount.<br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.read'
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}'
function Accounts.Service.accounts_v1_subaccounts_(
  @description : 'The GUID of the subaccount'
  @openapi.in : 'path'
  subaccountGUID : String,
  @assert.range : true
  @description : `The range of authorizations for which to return information.
* any: Returns all global accounts for which the user has authorizations on any of the accounts' entities, such as its subaccounts (for example, user is a subaccount admin) or spaces (for example, user is a Cloud Foundry space manager).
* (empty value): Returns all subaccounts for which the user has explicit authorization (\$XSAPPNAME.global-account.subaccount.read) on the global account or directory.`
  @openapi.in : 'query'
  derivedAuthorizations : String enum {
    ![any];
  }
) returns Accounts.Service_types.SubaccountResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Update a subaccount'
@Core.LongDescription : 'Update a subaccount in the global account.<br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.update'
@openapi.method : 'PATCH'
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}'
action Accounts.Service.accounts_v1_subaccounts__patch(
  @description : 'The GUID of the subaccount to update.'
  @openapi.in : 'path'
  subaccountGUID : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.UpdateSubaccountRequestPayload
) returns Accounts.Service_types.SubaccountResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Get custom properties for a subaccount (deprecated)'
@Core.LongDescription : ```
 Get all the user-defined custom properties that are assigned as key-value pairs to a given subaccount.

NOTE: This API is deprecated. Custom properties are now called labels. The "customProperties" field supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. This API returns only the first value of any label key that has multiple values assigned to it. Use instead: GET /accounts/v1/subaccounts/{subaccountGUID}/labels
 Required scope: \$XSAPPNAME.global-account.subaccount.read
```
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}/customProperties'
function Accounts.Service.accounts_v1_subaccounts__customProperties(
  @description : 'Unique ID of the subaccount.'
  @openapi.in : 'path'
  subaccountGUID : String
) returns Accounts.Service_types.ResponseCollection;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Remove all labels from a subaccount'
@Core.LongDescription : ```
Remove all user-defined labels that are assigned to a given subaccount.

To remove specific labels, use instead: PUT /accounts/v1/subaccounts/{subaccountGUID}/labels

Required scope: \$XSAPPNAME.global-account.subaccount.update
```
@openapi.method : 'DELETE'
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}/labels'
action Accounts.Service.accounts_v1_subaccounts__labels_delete(
  @description : 'The GUID of the subaccount.'
  @openapi.in : 'path'
  subaccountGUID : String
) returns Accounts.Service_types.LabelsResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Get labels for a subaccount'
@Core.LongDescription : `Get all the user-defined labels that are assigned as key-value pairs to a given subaccount. 

Required scope: \$XSAPPNAME.global-account.subaccount.read`
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}/labels'
function Accounts.Service.accounts_v1_subaccounts__labels(
  @description : 'The GUID of the subaccount.'
  @openapi.in : 'path'
  subaccountGUID : String
) returns Accounts.Service_types.LabelsResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Assign labels to a subaccount'
@Core.LongDescription : `Assign user-defined labels to a given subaccount. Labels are specified as key-value pairs. 

Required scope: \$XSAPPNAME.global-account.subaccount.update`
@openapi.method : 'PUT'
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}/labels'
action Accounts.Service.accounts_v1_subaccounts__labels_put(
  @description : 'Unique ID of the subaccount.'
  @openapi.in : 'path'
  subaccountGUID : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.LabelAssignmentRequestPayload
) returns Accounts.Service_types.LabelsResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Move a subaccount'
@Core.LongDescription : ```
Move a subaccount to a different directory or out of a directory to the global account.<br/><br/>Required scopes for source directory:
\$XSAPPNAME.global-account.subaccount.read,
\$XSAPPNAME.global-account.subaccount.delete.


Required scopes for target directory:
\$XSAPPNAME.global-account.subaccount.create
```
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}/move'
action Accounts.Service.accounts_v1_subaccounts__move_post(
  @description : 'The unique ID of the subaccount to move.'
  @openapi.in : 'path'
  subaccountGUID : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.MoveSubaccountRequestPayload
) returns Accounts.Service_types.SubaccountResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Delete a Service Manager binding'
@Core.LongDescription : 'Delete an existing Service Manager instance and binding that were created as the result of the *POST/accounts/v1/subaccounts/{subaccountGUID}/serviceManagementBinding* API call for a specified subaccount to access and work with the Service Management APIs.<br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.update'
@openapi.method : 'DELETE'
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}/serviceManagementBinding'
action Accounts.Service.accounts_v1_subaccounts__serviceManagementBinding_delete(
  @description : 'The GUID of the subaccount for which to delete this instance and binding.'
  @openapi.in : 'path'
  subaccountGUID : String
);

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Get a Service Manager binding'
@Core.LongDescription : 'View the details of an existing Service Manager binding that was created as the result of the *POST /accounts/v1/subaccounts/{subaccountGUID}/serviceManagementBinding* API call for a specified subaccount to access and work with the Service Management APIs.<br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.read'
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}/serviceManagementBinding'
function Accounts.Service.accounts_v1_subaccounts__serviceManagementBinding(
  @description : 'The GUID of the subaccount for which to get the binding.'
  @openapi.in : 'path'
  subaccountGUID : String
) returns Accounts.Service_types.ServiceManagerBindingResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Create a Service Manager binding'
@Core.LongDescription : ```
Use this API to create a service instance and binding for a specified subaccount to get credentials to access Service Manager APIs.<br><br> We create this instance and binding for you directly in your subaccount, and as such, they are not associated with or restricted to any specific environment.<br> The instance and binding created with this API have generic names:<br> - ServiceManagementAccessInstance<br> - ServiceManagementAccessBinding

  **Tip**
 To view the created instance and binding, use the GET /accounts/v1/subaccounts/{subaccountGUID}/serviceManagementBinding API.<br/><br/>Required scope: \$XSAPPNAME.global-account.subaccount.update
```
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}/serviceManagementBinding'
action Accounts.Service.accounts_v1_subaccounts__serviceManagementBinding_post(
  @description : 'The GUID of the subaccount for which to create a binding to access Service Manager.'
  @openapi.in : 'path'
  subaccountGUID : String
) returns Accounts.Service_types.ServiceManagerBindingResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Delete subaccount settings'
@Core.LongDescription : 'Delete subaccount settings for a specified subaccount.<br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.update'
@openapi.method : 'DELETE'
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}/settings'
action Accounts.Service.accounts_v1_subaccounts__settings_delete(
  @description : 'The GUID of the subaccount.'
  @openapi.in : 'path'
  subaccountGUID : String,
  @description : 'Keys for the property. Limited to 255 characters.'
  @openapi.in : 'query'
  @openapi.required : true
  keys : many String
) returns Accounts.Service_types.DataResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Get subaccount settings'
@Core.LongDescription : 'Get subaccount settings for a specified subaccount.<br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.read'
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}/settings'
function Accounts.Service.accounts_v1_subaccounts__settings(
  @description : 'The GUID of the subaccount.'
  @openapi.in : 'path'
  subaccountGUID : String,
  @description : 'Keys for the property. Limited to 255 characters.'
  @openapi.in : 'query'
  keys : many String
) returns Accounts.Service_types.DataResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Create or update subaccount settings'
@Core.LongDescription : 'Create or update subaccount settings for a specified subaccount.<br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.update'
@openapi.method : 'PUT'
@openapi.path : '/accounts/v1/subaccounts/{subaccountGUID}/settings'
action Accounts.Service.accounts_v1_subaccounts__settings_put(
  @description : 'The GUID of the subaccount.'
  @openapi.in : 'path'
  subaccountGUID : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.EntitySettingsRequestPayload
) returns Accounts.Service_types.DataResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Get all Service Manager bindings'
@Core.LongDescription : 'View all Service Manager bindings.<br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.read'
@openapi.path : '/accounts/v2/subaccounts/{subaccountGUID}/serviceManagerBindings'
function Accounts.Service.accounts_v2_subaccounts__serviceManagerBindings(
  @description : 'The GUID of the subaccount for which to get the bindings.'
  @openapi.in : 'path'
  subaccountGUID : String
) returns Accounts.Service_types.ServiceManagerBindingsResponseList;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Create a Service Manager binding'
@Core.LongDescription : ```
Use this API to create a service instance and associated bindings for a specified subaccount to get credentials to access Service Manager APIs.<br><br> We create this instance and bindings for you directly in your subaccount, and as such, they are not associated with or restricted to any specific environment.<br> The instance created with this API has a generic name:<br> - ServiceManagementAccessInstance<br><br> You can create more than one binding associated with the created service instance.<br> This has many benefits, for example if you need to use credentials rotation.<br><br>There are two types of service bindings you can create, depending on the credentials type:<br> - Binding with Basic credentials<br> - Binding with mTLS credentials<br><br> The binding with Basic credentials is a default type that you get without specifying any parameters in the *CreateServiceManagerBindingRequestPayload* object. If you wish to use the mTLS type, specify parameters.<br> For example: {
 "credential-type": "x509",
 "x509": {
 "key-length": 2048,
 "validity": 7,
 "validity-type": "DAYS"
 }

  **Tip**
 To view the created instance and bindings, use the *GET /accounts/accounts/v2/subaccounts/{subaccountGUID}/serviceManagerBindings/{bindingName}* API.<br/><br/>Required scope: \$XSAPPNAME.global-account.subaccount.update
```
@openapi.path : '/accounts/v2/subaccounts/{subaccountGUID}/serviceManagerBindings'
action Accounts.Service.accounts_v2_subaccounts__serviceManagerBindings_post(
  @description : 'The GUID of the subaccount for which to create a binding to access Service Manager.'
  @openapi.in : 'path'
  subaccountGUID : String,
  @openapi.in : 'body'
  body : Accounts.Service_types.CreateServiceManagerBindingRequestPayload
) returns Accounts.Service_types.ServiceManagerBindingExtendedResponseObject;

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Delete a Service Manager binding'
@Core.LongDescription : 'Delete an existing Service Manager binding. <br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.update'
@openapi.method : 'DELETE'
@openapi.path : '/accounts/v2/subaccounts/{subaccountGUID}/serviceManagerBindings/{bindingName}'
action Accounts.Service.accounts_v2_subaccounts__serviceManagerBindings__delete(
  @description : 'The GUID of the subaccount for which to delete this binding.'
  @openapi.in : 'path'
  subaccountGUID : String,
  @description : 'The name of the binding to delete.'
  @openapi.in : 'path'
  bindingName : String
);

@Common.Label : 'Subaccount Operations'
@Core.Description : 'Get a Service Manager binding'
@Core.LongDescription : 'View the details of an existing Service Manager binding.<br/><br/>Required scope: $XSAPPNAME.global-account.subaccount.read'
@openapi.path : '/accounts/v2/subaccounts/{subaccountGUID}/serviceManagerBindings/{bindingName}'
function Accounts.Service.accounts_v2_subaccounts__serviceManagerBindings_(
  @description : 'The GUID of the subaccount for which to get the binding.'
  @openapi.in : 'path'
  subaccountGUID : String,
  @description : 'The name of the binding for which to get details.'
  @openapi.in : 'path'
  bindingName : String
) returns Accounts.Service_types.ServiceManagerBindingExtendedResponseObject;

@Common.Label : 'Job Management'
@Core.Description : 'Get job status'
@Core.LongDescription : 'Get information for a specified job, including its ID and its current status.<br/><br/>Required scope: $XSAPPNAME.job.read'
@openapi.path : '/jobs-management/v1/jobs/{jobInstanceIdOrUniqueId}/status'
function Accounts.Service.jobs_management_v1_jobs__status(
  @description : 'ID of the job for which to get status'
  @openapi.in : 'path'
  jobInstanceIdOrUniqueId : String
) returns Accounts.Service_types.JobStatusResponseObject;

@description : `(Deprecated) User-defined labels to assign, update, and remove as key-value pairs from the subaccount. 
NOTE: This field is deprecated. "customProperties" supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. The "customProperties" field overwrites any labels with the same key. We recommend transitioning to the "labels" field. Do not include "customProperties" and "labels" together in the same request (customProperties will be ignored).
`
type Accounts.Service_types.AddPropertyRequestPayload {
  @description : 'A name for the label up to 63 characters. Attribute is case-sensitive -- try to avoid creating duplicate variants of the same keys with a different casing.'
  ![key] : String;
  @description : 'An optional value for the corresponding label key up to 63 characters. Attribute is case-sensitive -- try to avoid creating duplicate variants of the same value with a different casing.'
  value : { };
};

@description : 'Details of the new subaccount.'
type Accounts.Service_types.CloneNeoSubaccountRequestPayload {
  @description : 'Enables the subaccount to use beta services and applications. Not to be used in a production environment. Cannot be reverted once set. Any use of beta functionality is at the customer''s own risk, and SAP shall not be liable for errors or damages caused by the use of beta features.'
  betaEnabled : Boolean;
  @description : 'Clone configuration of the subaccount.'
  cloneConfigurations : many Accounts.Service.anonymous.type0;
  @description : `(Deprecated) User-defined labels to assign, update, and remove as key-value pairs from the subaccount. 
NOTE: This field is deprecated. "customProperties" supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. The "customProperties" field overwrites any labels with the same key. We recommend transitioning to the "labels" field. Do not include "customProperties" and "labels" together in the same request (customProperties will be ignored).
`
  customProperties : many Accounts.Service_types.AddPropertyRequestPayload;
  @description : 'A description of the subaccount for customer-facing UIs.'
  description : String;
  @description : 'The display name of the subaccount for customer-facing UIs.'
  @assert.format : '^((?![/]).)*$'
  displayName : String;
  @description : ```
  JSON array of up to 10 user-defined labels to assign as key-value pairs to the subaccount. Each label has a name (key) that you specify, and to which you can assign up to 10 corresponding values or leave empty. 
  
  Keys and values are each limited to 63 characters. 
  
  The keys and values of labels are case-sensitive. Try to avoid creating duplicate variants of the same keys or values with a different casing (example: "myValue" and "MyValue").
  
  
  
  Example:
  
  {
  
    "Cost Center": ["19700626"],
  
    "Department": ["Sales"],
  
    "Contacts": ["name1@example.com","name2@example.com"],
  
    "EMEA":[]
  
  }
  ```
  labels : { };
  @description : `The origin of the subaccount creation.
* <b>API:</b> Subaccount is created/updated by an admin using the REST APIs of the Accounts service.`
  @assert.range : true
  origin : String enum {
    API;
  };
  @description : 'The unique ID subaccount’s parent entity.'
  parentGUID : String;
  @description : 'The region in which the subaccount was created.'
  region : String;
  @description : 'List of additional admins of the subaccount. You can add users only from the same user base as you (example: sap.default or custom identity provider). Do not add yourself as you are assigned by default. Enter inline as a valid JSON array. Specify the admins by user IDs for Neo subaccounts and e-mails for multi-environment subaccounts.'
  subaccountAdmins : many Accounts.Service.anonymous.type1;
  @description : 'The subdomain that becomes part of the path used to access the authorization tenant of the subaccount. Must be unique within the defined region. Use only letters (a-z), digits (0-9), and hyphens (not at start or end). Maximum length is 63 characters. Cannot be changed after the subaccount has been created. Does not apply to Neo subaccounts.'
  subdomain : String;
  @description : ```
  Whether the subaccount is used for production purposes. This flag can help your cloud operator to take appropriate action when handling incidents that are related to mission-critical accounts in production systems. Do not apply for subaccounts that are used for non-production purposes, such as development, testing, and demos. Applying this setting this does not modify the subaccount.
  * <b>NOT_USED_FOR_PRODUCTION:</b> Subaccount is not used for production purposes.
  * <b>USED_FOR_PRODUCTION:</b> Subaccount is used for production purposes. 
  
  ```
  @assert.range : true
  usedForProduction : String enum {
    USED_FOR_PRODUCTION;
    NOT_USED_FOR_PRODUCTION;
  };
};

@description : 'Details of the directory to create.'
type Accounts.Service_types.CreateDirectoryRequestPayload {
  @description : `(Deprecated) User-defined labels to assign, update, and remove as key-value pairs from the directory. 
NOTE: This field is deprecated. "customProperties" supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. The "customProperties" field overwrites any labels with the same key. We recommend transitioning to the "labels" field. Do not include "customProperties" and "labels" together in the same request (customProperties will be ignored).
`
  customProperties : many Accounts.Service_types.AddPropertyRequestPayload;
  @description : 'A description of the directory.'
  description : String;
  directoryAdmins : many Accounts.Service.anonymous.type2;
  directoryFeatures : many Accounts.Service.anonymous.type3;
  @description : 'The display name of the directory.'
  @assert.format : '^((?![/]).)*$'
  displayName : String;
  @description : ```
  JSON array of up to 10 user-defined labels to assign as key-value pairs to the directory. Each label has a name (key) that you specify, and to which you can assign up to 10 corresponding values or leave empty. 
  
  Keys and values are each limited to 63 characters. 
  
  Label keys and values are case-sensitive. Try to avoid creating duplicate variants of the same keys or values with a different casing (example: "myValue" and "MyValue").
  
  
  
  Example: 
  
  {
  
    "Cost Center": ["19700626"],
  
    "Department": ["Sales"],
  
    "Contacts": ["name1@example.com","name2@example.com"],
  
    "EMEA":[]
  
  }
  
  
  ```
  labels : { };
  @description : 'Applies only to directories that have the user authorization management feature enabled. The subdomain becomes part of the path used to access the authorization tenant of the directory. Must be unique in the defined region. Use only letters (a-z), digits (0-9), and hyphens (not at start or end). Maximum length is 63 characters. Cannot be changed after the directory has been created.'
  subdomain : String;
};

@description : 'Details of the new Service Manager binding.'
type Accounts.Service_types.CreateServiceManagerBindingRequestPayload {
  @description : 'Specify the name of the service binding.'
  name : String;
  @description : 'Service-specific configuration parameters. For example, mTLS authentication-type parameters.'
  parameters : { };
};

@description : 'Details of the new subaccount.'
type Accounts.Service_types.CreateSubaccountRequestPayload {
  @description : 'Enables the subaccount to use beta services and applications. Not to be used in a production environment. Cannot be reverted once set. Any use of beta functionality is at the customer''s own risk, and SAP shall not be liable for errors or damages caused by the use of beta features.'
  betaEnabled : Boolean;
  @description : `(Deprecated) User-defined labels to assign, update, and remove as key-value pairs from the subaccount. 
NOTE: This field is deprecated. "customProperties" supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. The "customProperties" field overwrites any labels with the same key. We recommend transitioning to the "labels" field. Do not include "customProperties" and "labels" together in the same request (customProperties will be ignored).
`
  customProperties : many Accounts.Service_types.AddPropertyRequestPayload;
  @description : 'A description of the subaccount for customer-facing UIs.'
  description : String;
  @description : 'The display name of the subaccount for customer-facing UIs.'
  @assert.format : '^((?![/]).)*$'
  displayName : String;
  @description : ```
  JSON array of up to 10 user-defined labels to assign as key-value pairs to the subaccount. Each label has a name (key) that you specify, and to which you can assign up to 10 corresponding values or leave empty. 
  
  Keys and values are each limited to 63 characters. 
  
  The keys and values of labels are case-sensitive. Try to avoid creating duplicate variants of the same keys or values with a different casing (example: "myValue" and "MyValue").
  
  
  
  Example:
  
  {
  
    "Cost Center": ["19700626"],
  
    "Department": ["Sales"],
  
    "Contacts": ["name1@example.com","name2@example.com"],
  
    "EMEA":[]
  
  }
  ```
  labels : { };
  @description : `The origin of the subaccount creation.
* <b>API:</b> Subaccount is created/updated by an admin using the REST APIs of the Accounts service.`
  @assert.range : true
  origin : String enum {
    API;
  };
  @description : 'The unique ID subaccount’s parent entity.'
  parentGUID : String;
  @description : 'The region in which the subaccount was created.'
  region : String;
  @description : 'List of additional admins of the subaccount. You can add users only from the same user base as you (example: sap.default or custom identity provider). Do not add yourself as you are assigned by default. Enter inline as a valid JSON array. Specify the admins by user IDs for Neo subaccounts and e-mails for multi-environment subaccounts.'
  subaccountAdmins : many Accounts.Service.anonymous.type4;
  @description : 'The subdomain that becomes part of the path used to access the authorization tenant of the subaccount. Must be unique within the defined region. Use only letters (a-z), digits (0-9), and hyphens (not at start or end). Maximum length is 63 characters. Cannot be changed after the subaccount has been created. Does not apply to Neo subaccounts.'
  subdomain : String;
  @description : ```
  Whether the subaccount is used for production purposes. This flag can help your cloud operator to take appropriate action when handling incidents that are related to mission-critical accounts in production systems. Do not apply for subaccounts that are used for non-production purposes, such as development, testing, and demos. Applying this setting this does not modify the subaccount.
  * <b>NOT_USED_FOR_PRODUCTION:</b> Subaccount is not used for production purposes.
  * <b>USED_FOR_PRODUCTION:</b> Subaccount is used for production purposes. 
  
  ```
  @assert.range : true
  usedForProduction : String enum {
    USED_FOR_PRODUCTION;
    NOT_USED_FOR_PRODUCTION;
  };
};

type Accounts.Service_types.DataResponseObject {
  @description : 'The response object containing information about the data.'
  values : many Accounts.Service_types.PropertyDataResponseObject;
};

type Accounts.Service_types.DirectoryResponseObject {
  @description : ```
  The status of the customer contract and its associated root global account.
  * <b>ACTIVE:</b> The customer contract and its associated global account is currently active.
  * <b>PENDING_TERMINATION:</b> A termination process has been triggered for a customer contract (the customer contract has expired, or a customer has given notification that they wish to terminate their contract), and the global account is currently in the validation period. The customer can still access their global account until the end of the validation period.
  * <b>SUSPENDED:</b> For enterprise accounts, specifies that the customer's global account is currently in the grace period of the termination process. Access to the global account by the customer is blocked. No data is deleted until the deletion date is reached at the end of the grace period. For trial accounts, specifies that the account is suspended, and the account owner has not yet extended the trial period.
  ```
  @assert.range : true
  contractStatus : String enum {
    ACTIVE;
    PENDING_TERMINATION;
    SUSPENDED;
  };
  @description : 'Details of the user that created the directory.'
  createdBy : String;
  @description : 'The date the directory was created. Dates and times are in UTC format.'
  createdDate : Timestamp;
  @description : 'Custom properties assigned to the directory as key-value pairs.'
  customProperties : many Accounts.Service_types.PropertyResponseObject;
  @description : 'A description of the directory.'
  description : String;
  directoryFeatures : many Accounts.Service.anonymous.type5;
  @description : 'The display name of the directory.'
  displayName : String;
  @description : ```
  The current state of the directory.
  * <b>STARTED:</b> CRUD operation on an entity has started.
  * <b>CREATING:</b> Creating entity operation is in progress.
  * <b>UPDATING:</b> Updating entity operation is in progress.
  * <b>MOVING:</b> Moving entity operation is in progress.
  * <b>PROCESSING:</b> A series of operations related to the entity is in progress.
  * <b>DELETING:</b> Deleting entity operation is in progress.
  * <b>OK:</b> The CRUD operation or series of operations completed successfully.
  * <b>PENDING_REVIEW:</b> The processing operation has been stopped for reviewing and can be restarted by the operator.
  * <b>CANCELLED:</b> The operation or processing was canceled by the operator.
  * <b>CREATION_FAILED:</b> The creation operation failed, and the entity was not created or was created but cannot be used.
  * <b>UPDATE_FAILED:</b> The update operation failed, and the entity was not updated.
  * <b>PROCESSING_FAILED:</b> The processing operations failed.
  * <b>DELETION_FAILED:</b> The delete operation failed, and the entity was not deleted.
  * <b>MOVE_FAILED:</b> Entity could not be moved to a different location.
  * <b>MIGRATING:</b> Migrating entity from NEO to CF.
  ```
  @assert.range : true
  entityState : String enum {
    STARTED;
    CREATING;
    UPDATING;
    MOVING;
    MOVING_TO_OTHER_GA;
    PROCESSING;
    DELETING;
    OK;
    PENDING_REVIEW;
    CANCELED;
    CREATION_FAILED;
    UPDATE_FAILED;
    SUSPENSION_FAILED;
    UPDATE_ACCOUNT_TYPE_FAILED;
    UPDATE_DIRECTORY_TYPE_FAILED;
    PROCESSING_FAILED;
    DELETION_FAILED;
    MOVE_FAILED;
    MOVE_TO_OTHER_GA_FAILED;
    MIGRATING;
    MIGRATION_FAILED;
    ROLLBACK_MIGRATION_PROCESSING;
    MIGRATED;
  };
  @description : 'The GUID of the directory''s global account entity.'
  globalAccountGUID : String;
  @description : 'The unique ID of the directory.'
  guid : String;
  @description : 'Contains information about the labels assigned to a specified global account. Labels are represented in a JSON array of key-value pairs; each key has up to 10 corresponding values. This field replaces the deprecated "customProperties" field, which supports only single values per key.'
  labels : { };
  legalLinks : Accounts.Service_types.LegalLinksDTO;
  @description : 'The date the directory was last modified. Dates and times are in UTC format.'
  modifiedDate : Timestamp;
  @description : 'The GUID of the directory''s parent entity. Typically this is the global account.'
  parentGUID : String;
  @description : 'Information about the state.'
  stateMessage : String;
  @description : 'The subaccounts contained in the directory.'
  subaccounts : many Accounts.Service_types.SubaccountResponseObject;
  @description : 'Applies only to directories that have the user authorization management feature enabled. The subdomain becomes part of the path used to access the authorization tenant of the directory. Unique within the defined region.'
  subdomain : String;
};

@description : 'New and/or updated directory settings.'
type Accounts.Service_types.EntitySettingsRequestPayload {
  @description : 'Additional properties for the settings.'
  entitySettings : many Accounts.Service_types.UpdateEntitySettingsRequestPayload;
};

type Accounts.Service_types.ErrorResponse {
  @description : 'Technical code of the error as a reference for support'
  code : Integer;
  @description : 'Log correlation ID to track the event'
  correlationID : String;
  @description : 'Error description in JSON format'
  description : String;
  details : many Accounts.Service_types.NestingErrorDetailsResponseObject;
  @description : 'User-friendly description of the error.'
  message : String;
  @description : 'Describes a data element (for example, a resource path: /online-store/v1/products/123)'
  target : String;
};

type Accounts.Service_types.GlobalAccountResponseObject {
  @description : 'Specifies if global account is backward-compliant for EU access.'
  backwardCompliantEU : Boolean;
  @description : 'The customer ID of the third-party global account operated by SAP customer global account.  Retrieved from the Custom field of the third party customer''s order.'
  bpoCustomerId : String;
  @description : 'The list of directories associated with the specified global account.'
  children : many Accounts.Service_types.DirectoryResponseObject;
  @description : 'The type of the commercial contract that was signed.'
  commercialModel : String;
  @description : `Whether the customer of the global account pays only for services that they actually use (consumption-based) or pay for subscribed services at a fixed cost irrespective of consumption (subscription-based).
* <b>TRUE:</b> Consumption-based commercial model.
* <b>FALSE:</b> Subscription-based commercial model.`
  consumptionBased : Boolean;
  @description : ```
  The status of the customer contract and its associated root global account.
  * <b>ACTIVE:</b> The customer contract and its associated global account is currently active.
  * <b>PENDING_TERMINATION:</b> A termination process has been triggered for a customer contract (the customer contract has expired, or a customer has given notification that they wish to terminate their contract), and the global account is currently in the validation period. The customer can still access their global account until the end of the validation period.
  * <b>SUSPENDED:</b> For enterprise accounts, specifies that the customer's global account is currently in the grace period of the termination process. Access to the global account by the customer is blocked. No data is deleted until the deletion date is reached at the end of the grace period. For trial accounts, specifies that the account is suspended, and the account owner has not yet extended the trial period.
  ```
  @assert.range : true
  contractStatus : String enum {
    ACTIVE;
    PENDING_TERMINATION;
    SUSPENDED;
  };
  @description : 'The number of the cost center that is charged for the creation and usage of the global account. This is a duplicate property used for backward compatibility; the cost center is also stored in costObjectId. This property must be null if the global account is tied to an internal order or Work Breakdown Structure element.'
  costCenter : String;
  @description : 'The number or code of the cost center, internal order, or Work Breakdown Structure element that is charged for the creation and usage of the global account. The type of the cost object must be configured in costObjectType.'
  costObjectId : String;
  @description : 'The type of accounting assignment object that is associated with the global account owner and used to charge for the creation and usage of the global account. Support types: COST_CENTER, INTERNAL_ORDER, WBS_ELEMENT. The number or code of the specified cost object is defined in costObjectId. For a cost object of type ''cost center'', the value is also configured in costCenter for backward compatibility purposes.'
  @assert.range : true
  costObjectType : String enum {
    COST_CENTER;
    INTERNAL_ORDER;
    WBS_ELEMENT;
  };
  @description : 'The date the global account was created. Dates and times are in UTC format.'
  createdDate : Timestamp;
  @description : 'The ID of the customer as registered in the CRM system.'
  crmCustomerId : String;
  @description : 'The ID of the customer tenant as registered in the CRM system.'
  crmTenantId : String;
  @description : '(Deprecated) Contains information about the labels assigned to a specified global account. This field supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. The "customProperties" field returns only the first value of any label key that has multiple values assigned to it.'
  customProperties : many Accounts.Service_types.PropertyResponseObject;
  @description : 'A description of the global account.'
  description : String;
  @description : 'The display name of the global account.'
  displayName : String;
  @description : ```
  The current state of the global account.
  * <b>STARTED:</b> CRUD operation on an entity has started.
  * <b>CREATING:</b> Creating entity operation is in progress.
  * <b>UPDATING:</b> Updating entity operation is in progress.
  * <b>MOVING:</b> Moving entity operation is in progress.
  * <b>PROCESSING:</b> A series of operations related to the entity is in progress.
  * <b>DELETING:</b> Deleting entity operation is in progress.
  * <b>OK:</b> The CRUD operation or series of operations completed successfully.
  * <b>PENDING_REVIEW:</b> The processing operation has been stopped for reviewing and can be restarted by the operator.
  * <b>CANCELLED:</b> The operation or processing was canceled by the operator.
  * <b>CREATION_FAILED:</b> The creation operation failed, and the entity was not created or was created but cannot be used.
  * <b>UPDATE_FAILED:</b> The update operation failed, and the entity was not updated.
  * <b>PROCESSING_FAILED:</b> The processing operations failed.
  * <b>DELETION_FAILED:</b> The delete operation failed, and the entity was not deleted.
  * <b>MOVE_FAILED:</b> Entity could not be moved to a different location.
  * <b>MIGRATING:</b> Migrating entity from NEO to CF.
  ```
  @assert.range : true
  entityState : String enum {
    STARTED;
    CREATING;
    UPDATING;
    MOVING;
    MOVING_TO_OTHER_GA;
    PROCESSING;
    DELETING;
    OK;
    PENDING_REVIEW;
    CANCELED;
    CREATION_FAILED;
    UPDATE_FAILED;
    SUSPENSION_FAILED;
    UPDATE_ACCOUNT_TYPE_FAILED;
    UPDATE_DIRECTORY_TYPE_FAILED;
    PROCESSING_FAILED;
    DELETION_FAILED;
    MOVE_FAILED;
    MOVE_TO_OTHER_GA_FAILED;
    MIGRATING;
    MIGRATION_FAILED;
    ROLLBACK_MIGRATION_PROCESSING;
    MIGRATED;
  };
  @description : `The planned date that the global account expires. This is the same date as the Contract End Date, unless a manual adjustment has been made to the actual expiration date of the global account.
Typically, this property is automatically populated only when a formal termination order is received from the CRM system.
From a customer perspective, this date marks the start of the grace period, which is typically 30 days before the actual deletion of the account.`
  expiryDate : Timestamp;
  @description : `The geographic locations from where the global account can be accessed.
* <b>STANDARD:</b> The global account can be accessed from any geographic location.
* <b>EU_ACCESS:</b> The global account can be accessed only within locations in the EU.`
  @assert.range : true
  geoAccess : String enum {
    STANDARD;
    EU_ACCESS;
  };
  @description : 'The GUID of the directory''s global account entity.'
  globalAccountGUID : String;
  @description : 'The unique ID of the global account.'
  guid : String;
  @description : 'Contains information about the labels assigned to a specified global account. Labels are represented in a JSON array of key-value pairs; each key has up to 10 corresponding values. This field replaces the deprecated "customProperties" field, which supports only single values per key.'
  labels : { };
  legalLinks : Accounts.Service_types.LegalLinksDTO;
  @description : ```
  The type of license for the global account. The license type affects the scope of functions of the account.
  * <b>DEVELOPER:</b> For internal developer global accounts on Staging or Canary landscapes.
  * <b>CUSTOMER:</b> For customer global accounts.
  * <b>PARTNER:</b> For partner global accounts.
  * <b>INTERNAL_DEV:</b> For internal global accounts on the Dev landscape.
  * <b>INTERNAL_PROD:</b> For internal global accounts on the Live landscape.
  * <b>TRIAL:</b> For customer trial accounts.
  ```
  @assert.range : true
  licenseType : String enum {
    DEVELOPER;
    CUSTOMER;
    PARTNER;
    INTERNAL_DEV;
    INTERNAL_PROD;
    SYSTEM;
    TRIAL;
    SAPDEV;
    SAPPROD;
    UNKNOWN;
  };
  @description : 'The date the global account was last modified. Dates and times are in UTC format.'
  modifiedDate : Timestamp;
  @description : ```
  The origin of the account.
  * <b>ORDER:</b> Created by the Order Processing API or Submit Order wizard.
  * <b>OPERATOR:</b> Created by the Global Account wizard.
  * <b>REGION_SETUP:</b> Created automatically as part of the region setup.
  ```
  @assert.range : true
  origin : String enum {
    ORDER;
    OPERATOR;
    REGION_SETUP;
  };
  @description : 'The GUID of the global account''s parent entity. Typically this is the global account.'
  parentGUID : String;
  @description : 'The Type of the global account''s parent entity.'
  @assert.range : true
  parentType : String enum {
    ROOT;
    GLOBAL_ACCOUNT;
    PROJECT;
    GROUP;
    FOLDER;
  };
  @description : 'The date that an expired contract was renewed. Dates and times are in UTC format.'
  renewalDate : Timestamp;
  @description : 'For internal accounts, the service for which the global account was created.'
  serviceId : String;
  @description : 'Information about the state.'
  stateMessage : String;
  @description : 'The subaccounts contained in the global account.'
  subaccounts : many Accounts.Service_types.SubaccountResponseObject;
  @description : 'Relevant only for entities that require authorization (e.g. global account). The subdomain that becomes part of the path used to access the authorization tenant of the global account. Unique within the defined region.'
  subdomain : String;
  @description : ```
  Specifies the current stage of the termination notifications sequence.
  * <b>PENDING_FIRST_NOTIFICATION:</b> A notification has not yet been sent to the global account owner informing them of the expired contract or termination request.
  * <b>FIRST_NOTIFICATION_PROCESSED:</b> A first notification has been sent to the global account owner informing them of the expired contract, and the termination date when the global account will be closed.
  * <b>SECOND_NOTIFICATION_PROCESSED:</b> A follow-up notification has been sent to the global account owner.
  
  Your mail server must be configured so that termination notifications can be sent by the Core Commercialization Foundation service. 
  ```
  @assert.range : true
  terminationNotificationStatus : String enum {
    PENDING_FIRST_NOTIFICATION;
    FIRST_NOTIFICATION_PROCESSED;
    SECOND_NOTIFICATION_PROCESSED;
    NOTIFICATION_PROCESSED;
  };
  @description : ```
  For internal accounts, the intended purpose of the global account. Possible purposes:
  * <b>Development:</b> For development of a service.
  * <b>Testing:</b> For testing development.
  * <b>Demo:</b> For creating demos.
  * <b>Production:</b> For delivering a service in a production landscape.
  ```
  useFor : String;
};

type Accounts.Service_types.JobParameter {
  identifying : Boolean;
  @assert.range : true
  type : String enum {
    STRING;
    DATE;
    LONG;
    DOUBLE;
  };
  value : { };
};

type Accounts.Service_types.JobStatusResponseObject {
  customParams : { };
  @description : 'A description of the exit status of a job when it ends.'
  description : String;
  jobParams : { };
  @description : ```
  The current state of the job. 
  * <b>IN_PROGRESS:</b> The job is being executed.
  * <b>COMPLETED:</b> The job has completed.
  * <b>FAILED:</b> The job failed and did not complete. The job can be restarted.
  ```
  @assert.range : true
  status : String enum {
    IN_PROGRESS;
    COMPLETED;
    FAILED;
  };
  statusDetails : { };
};

@description : 'JSON object with labels as key-value pairs'
type Accounts.Service_types.LabelAssignmentRequestPayload {
  @description : ```
  Labels as key-value pairs in JSON format. An entity is allowed up to 10 labels. The key of each label is mandatory and is limited to 63 characters. Standard labels can have any name (key) that you define, with only a single optional value assigned per key. To define a special type of label, called tags, specify the key with the name 'tags' and associate up to 10 values per tag in the array. The key 'tags' (in any casing variation) can only be used once per entity. Note that label values (not keys) are case-sensitive -- be careful not to create duplicate variants of the same value with a different casing (example: "myValue" and "MyValue").
  
  For example: {
  
  "Cost Center":"2624061970"
  
  "Department":"Sales"
  
  "tags": ["Green", "Pharma", "Audited"]
  
  }
  ```
  labels : { };
};

@description : 'Labels assigned as key-value pairs to the entity.'
type Accounts.Service_types.LabelsResponseObject {
  @description : ```
  User-defined labels that are assigned as key-value pairs in a JSON array to the entity.
  
  Example: {
  
     "Cost Center": ["19700626"],
  
     "Department": ["Sales"],
  
     "Contacts": ["name1@example.com","name2@example.com"],
  
     "EMEA":[]
  
  }
  ```
  labels : { };
};

type Accounts.Service_types.LegalLinksDTO {
  privacy : String;
};

@description : 'Details of where to move the subaccount to.'
type Accounts.Service_types.MoveSubaccountRequestPayload {
  @description : 'The GUID of the new location of the subaccount. To move to a directory, enter the GUID of the directory. To move out of a directory to the root global account, enter the GUID of the global account.'
  targetAccountGUID : String;
};

@description : 'Provide the parameters necessary to obtain information about the source and the target locations.'
type Accounts.Service_types.MoveSubaccountsRequestPayload {
  @description : 'The GUID of the current location of the subaccounts. If empty, then GUID of root global account is used.'
  sourceGuid : String;
  @description : 'GUIDs of the subaccounts to move.'
  subaccountGuids : many Accounts.Service.anonymous.type6;
  @description : 'The GUID of the new location of the subaccounts. To move to a directory, enter the GUID of the directory. To move out of a directory to the root global account, enter the GUID of the global account.'
  targetGuid : String;
};

@description : 'Details of which subaccounts to move and where to move them to. All subaccounts must be moved to the same location.'
type Accounts.Service_types.MoveSubaccountsRequestPayloadCollection {
  @description : 'Provide the parameters necessary to obtain information about the source and the target locations.'
  subaccountsToMoveCollection : many Accounts.Service_types.MoveSubaccountsRequestPayload;
};

type Accounts.Service_types.NestingErrorDetailsResponseObject {
  code : Integer;
  message : String;
};

@description : 'The response object containing information about the data.'
type Accounts.Service_types.PropertyDataResponseObject {
  @description : 'The sub-categories associated with the metadata definitions.'
  classification : String;
  @description : 'A default value for the corresponding entity type.'
  defaultValue : String;
  @description : 'A description for the corresponding metadata definition.'
  description : String;
  @description : 'Whether the dynamic property is calculated in runtime if it exists in the validation schema for the metadata.'
  dynamicProperty : Boolean;
  @description : 'The type of entity, namely, global account, subaccount, directory and so on.'
  entityType : String;
  @description : 'The unique ID of the entity type.'
  entityTypeGuid : String;
  @description : 'A name for the custom property of the entity type. Limited to 255 characters.'
  ![key] : String;
  @description : 'The metadata for the properties of the settings object and the valid values.'
  validationSchema : { };
  @description : 'The user-defined value for the corresponding key. Limited to 1024 characters.'
  value : { };
};

@description : '(Deprecated) Contains information about the labels assigned to a specified subaccount. This field supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. The "customProperties" field returns only the first value of any label key that has multiple values assigned to it.'
type Accounts.Service_types.PropertyResponseObject {
  @description : 'The unique ID for the corresponding entity.'
  accountGUID : String;
  @description : 'The name for the label.'
  ![key] : String;
  @description : 'The value for the corresponding label key.'
  value : String;
};

type Accounts.Service_types.ResponseCollection {
  value : many Accounts.Service_types.SubaccountResponseObject;
};

@description : 'Note that we are listing here all the possible fields that this object can contain. However, they aren''t all present in each object.<br>A binding that uses the Basic credentials type contains:<br>name, clientid, clientsecret, url, sm_url, creationDate, and xsappname.<br>A binding that uses the mTLS credentials type contains:<br>name, clientid, certificate, key, certUrl, sm_url, creationDate, and xsappname.'
type Accounts.Service_types.ServiceManagerBindingExtendedResponseObject {
  @description : 'URL to fetch the token.'
  certUrl : String;
  @description : 'A data file that contains important information for verifying a server''s or device''s identity, including the public key, a statement of who issued the certificate (TLS certificates are issued by a certificate authority), and the certificate''s expiration date.'
  certificate : String;
  @description : 'A public identifier of the app.'
  clientid : String;
  @description : 'Secret known only to the app and the authorization server.'
  clientsecret : String;
  @description : 'The time the Service Manager binding was created.<br>In ISO 8601 format:YYYY-MM-DDThh:mm:ssTZD.'
  creationDate : String;
  @description : 'Message to be decrypted.'
  ![key] : String;
  @description : 'The name of the service binding.'
  name : String;
  @description : 'The URL of Service Manager APIs to access with the obtained token.'
  sm_url : String;
  @description : 'The URL to authentication server to get a token to authenticate with Service Manager using the obtained client ID and secret.'
  url : String;
  @description : 'The name of the xsapp used to get the access token.'
  xsappname : String;
};

@description : 'OAuth 2.0 Client Credentials Grant Type to obtain an access token to use the Service Manager APIs in a subaccount context. The example and model are for the basic credentials type.'
type Accounts.Service_types.ServiceManagerBindingResponseObject {
  @description : 'A public identifier of the app.'
  clientid : String;
  @description : 'Secret known only to the app and the authorization server.'
  clientsecret : String;
  @description : 'The URL of Service Manager APIs to access with the obtained token.'
  sm_url : String;
  @description : 'The URL to authentication server to get a token to authenticate with Service Manager using the obtained client ID and secret.'
  url : String;
  @description : 'The name of the xsapp used to get the access token.'
  xsappname : String;
};

@description : 'The list of the Service Manager bindings for the specified subaccount GUID.'
type Accounts.Service_types.ServiceManagerBindingsResponseList {
  items : many Accounts.Service_types.ServiceManagerBindingExtendedResponseObject;
};

type Accounts.Service_types.SubaccountResponseObject {
  @description : 'Whether the subaccount can use beta services and applications.'
  betaEnabled : Boolean;
  @description : 'Details of the user that created the subaccount.'
  createdBy : String;
  @description : 'The date the subaccount was created. Dates and times are in UTC format.'
  createdDate : Timestamp;
  @description : '(Deprecated) Contains information about the labels assigned to a specified subaccount. This field supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. The "customProperties" field returns only the first value of any label key that has multiple values assigned to it.'
  customProperties : many Accounts.Service_types.PropertyResponseObject;
  @description : 'A description of the subaccount for customer-facing UIs.'
  description : String;
  @description : 'A descriptive name of the subaccount for customer-facing UIs.'
  displayName : String;
  @description : 'The unique ID of the subaccount''s global account.'
  globalAccountGUID : String;
  @description : 'Unique ID of the subaccount.'
  guid : String;
  @description : 'Contains information about the labels assigned to a specified subaccount. Labels are represented in a JSON array of key-value pairs; each key has up to 10 corresponding values. This field replaces the deprecated "customProperties" field, which supports only single values per key.'
  labels : { };
  @description : 'The date the subaccount was last modified. Dates and times are in UTC format.'
  modifiedDate : Timestamp;
  parentFeatures : many Accounts.Service.anonymous.type7;
  @description : 'The GUID of the subaccount’s parent entity. If the subaccount is located directly in the global account (not in a directory), then this is the GUID of the global account.'
  parentGUID : String;
  @description : 'The region in which the subaccount was created.'
  region : String;
  @description : 'The current state of the subaccount.'
  @assert.range : true
  state : String enum {
    STARTED;
    CREATING;
    UPDATING;
    MOVING;
    MOVING_TO_OTHER_GA;
    PROCESSING;
    DELETING;
    OK;
    PENDING_REVIEW;
    CANCELED;
    CREATION_FAILED;
    UPDATE_FAILED;
    SUSPENSION_FAILED;
    UPDATE_ACCOUNT_TYPE_FAILED;
    UPDATE_DIRECTORY_TYPE_FAILED;
    PROCESSING_FAILED;
    DELETION_FAILED;
    MOVE_FAILED;
    MOVE_TO_OTHER_GA_FAILED;
    MIGRATING;
    MIGRATION_FAILED;
    ROLLBACK_MIGRATION_PROCESSING;
    MIGRATED;
  };
  @description : 'Information about the state of the subaccount.'
  stateMessage : String;
  @description : 'The subdomain that becomes part of the path used to access the authorization tenant of the subaccount. Must be unique within the defined region. Use only letters (a-z), digits (0-9), and hyphens (not at the start or end). Maximum length is 63 characters. Cannot be changed after the subaccount has been created.'
  subdomain : String;
  @description : 'The technical name of the subaccount. Refers to: (1) the platform-based account name for Neo subaccounts, or (2) the account identifier (tenant ID) in XSUAA for multi-environment subaccounts.'
  technicalName : String;
  @description : ```
  Whether the subaccount is used for production purposes. This flag can help your cloud operator to take appropriate action when handling incidents that are related to mission-critical accounts in production systems. Do not apply for subaccounts that are used for non-production purposes, such as development, testing, and demos. Applying this setting this does not modify the subaccount.
  * <b>UNSET:</b> Global account or subaccount admin has not set the production-relevancy flag. Default value.
  * <b>NOT_USED_FOR_PRODUCTION:</b> Subaccount is not used for production purposes.
  * <b>USED_FOR_PRODUCTION:</b> Subaccount is used for production purposes. 
  
  ```
  @assert.range : true
  usedForProduction : String enum {
    UNSET;
    NOT_USED_FOR_PRODUCTION;
    USED_FOR_PRODUCTION;
  };
};

@description : 'Details of the directory properties to update.'
type Accounts.Service_types.UpdateDirectoryRequestPayload {
  @description : `(Deprecated) User-defined labels to assign, update, and remove as key-value pairs from the directory. 
NOTE: This field is deprecated. "customProperties" supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. The "customProperties" field overwrites any labels with the same key. We recommend transitioning to the "labels" field. Do not include "customProperties" and "labels" together in the same request (customProperties will be ignored).
`
  customProperties : many Accounts.Service_types.UpdatePropertyRequestPayload;
  @description : 'The description of the directory for the customer-facing UIs.'
  description : String;
  @description : 'The new descriptive name of the directory.'
  @assert.format : '^((?![/]).)*$'
  displayName : String;
  @description : ```
  JSON array of up to 10 user-defined labels to assign as key-value pairs to the directory. Each label has a name (key) that you specify, and to which you can assign up to 10 corresponding values or leave empty. Keys and values are each limited to 63 characters.
  
  
  
  Label keys and values are case-sensitive. Try to avoid creating duplicate variants of the same keys or values with a different casing (example: "myValue" and "MyValue").
  
  
  
  Example: 
  
  {
  
    "Cost Center": ["19700626"],
  
    "Department": ["Sales"],
  
    "Contacts": ["name1@example.com","name2@example.com"],
  
    "EMEA":[]
  
  }
  
  
  
  IMPORTANT: The JSON array overwrites any labels that are currently assigned to the subaccount. In the request, you must include not only new and updated key-value pairs, but also existing ones that you do not want changed. Omit keys/values that you want removed as labels from the subaccount. 
  
  
  
  Any labels previously set using the deprecated "customProperties" field are also overwritten.
  
  
  ```
  labels : { };
};

@description : 'The request payload containing the list of features to be enabled in the directory.'
type Accounts.Service_types.UpdateDirectoryTypeRequestPayload {
  directoryAdmins : many Accounts.Service.anonymous.type8;
  directoryFeatures : many Accounts.Service.anonymous.type9;
  @description : 'Applies only to directories that have the user authorization management feature enabled.  The subdomain becomes part of the path used to access the authorization tenant of the directory. Must be unique within the defined region. Use only letters (a-z), digits (0-9), and hyphens (not at start or end). Maximum length is 63 characters. Cannot be changed after the directory has been created.'
  subdomain : String;
};

@description : 'Settings as key-value pairs to assign, update, and remove from the entity.'
type Accounts.Service_types.UpdateEntitySettingsRequestPayload {
  @description : 'A key for the property. Limited to 200 characters.'
  ![key] : String;
  @description : 'A value for the corresponding key. Limited to 2000 characters.'
  value : { };
};

@description : 'New display name and/or description of the global account.'
type Accounts.Service_types.UpdateGlobalAccountRequestPayload {
  @description : `(Deprecated) User-defined labels to assign, update, and remove as key-value pairs from the global account. 
NOTE: This field is deprecated. "customProperties" supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. The "customProperties" field overwrites any labels with the same key. We recommend transitioning to the "labels" field. Do not include "customProperties" and "labels" together in the same request (customProperties will be ignored).
`
  customProperties : many Accounts.Service_types.UpdatePropertyRequestPayload;
  @description : 'A new display of the global account.'
  description : String;
  @description : 'The new descriptive name of the global account.'
  @assert.format : '^((?![/]).)*$'
  displayName : String;
  @description : ```
  JSON array of up to 10 user-defined labels to assign as key-value pairs to the global account. Each label has a name (key) that you specify, and to which you can assign up to 10 corresponding values or leave empty. Keys and values are each limited to 63 characters.
  
  Label keys and values are case-sensitive. Try to avoid creating duplicate variants of the same keys or values with a different casing (example: "myValue" and "MyValue").
  
  Example: 
  {
    "Cost Center": ["19700626"],
    "Department": ["Sales"],
    "Contacts": ["name1@example.com","name2@example.com"],
    "EMEA":[]
  }
  
  IMPORTANT : The JSON array overwrites any labels that are currently assigned to the global account. In the request, you must include not only new and updated key-value pairs, but also existing ones that you do not want changed. Omit keys/values that you want removed as labels from the global account. 
  
  Any labels previously set using the deprecated "customProperties" field are also overwritten.
  
  ```
  labels : { };
};

@description : '(Deprecated) Labels as key-value pairs to assign, update, and remove from the entity.'
type Accounts.Service_types.UpdatePropertyRequestPayload {
  @description : 'Whether to delete a label according to the specified key. Omit if you want the specified key to be added or updated in the entity.'
  delete : Boolean;
  @description : 'A name for the label up to 63 characters. Attribute is case-sensitive -- try to avoid creating duplicate variants of the same keys with a different casing.'
  ![key] : String;
  @description : 'An optional value for the corresponding label key up to 63 characters. Attribute is case-sensitive -- try to avoid creating duplicate variants of the same keys with a different casing.'
  value : { };
};

@description : 'Details of subaccount properties to update'
type Accounts.Service_types.UpdateSubaccountRequestPayload {
  @description : 'Enables the subaccount to use beta services and applications. Not to be used in a production environment. Cannot be reverted once set. Any use of beta functionality is at the customer''s own risk, and SAP shall not be liable for errors or damages caused by the use of beta features.'
  betaEnabled : Boolean;
  @description : `(Deprecated) User-defined labels to assign, update, and remove as key-value pairs from the subaccount. 
NOTE: This field is deprecated. "customProperties" supports only single values per key and is now replaced by the string array "labels", which supports multiple values per key. The "customProperties" field overwrites any labels with the same key. We recommend transitioning to the "labels" field. Do not include "customProperties" and "labels" together in the same request (customProperties will be ignored).
`
  customProperties : many Accounts.Service_types.UpdatePropertyRequestPayload;
  @description : 'A new description of the subaccount.'
  description : String;
  @description : 'The new display name of the subaccount.'
  @assert.format : '^((?![/]).)*$'
  displayName : String;
  @description : ```
  JSON array of up to 10 user-defined labels to assign as key-value pairs to the subaccount. Each label has a name (key) that you specify, and to which you can assign up to 10 corresponding values or leave empty. Keys and values are each limited to 63 characters.
  
  The keys and values of labels are case-sensitive. Try to avoid creating duplicate variants of the same keys or values with a different casing (example: "myValue" and "MyValue").
  
  Example: 
  
  {
  
    "Cost Center": ["19700626"],
  
    "Department": ["Sales"],
  
    "Contacts": ["name1@example.com","name2@example.com"],
  
    "EMEA":[]
  
  }
  
  IMPORTANT: The JSON array overwrites any labels that are currently assigned to the subaccount. In the request, you must include not only new and updated key-value pairs, but also existing ones that you do not want changed. Omit keys/values that you want removed as labels from the subaccount. 
  
  Any labels previously set using the deprecated "customProperties" field are also overwritten.
  
  ```
  labels : { };
  @description : ```
  Whether the subaccount is used for production purposes. This flag can help your cloud operator to take appropriate action when handling incidents that are related to mission-critical accounts in production systems. Do not apply for subaccounts that are used for non-production purposes, such as development, testing, and demos. Applying this setting this does not modify the subaccount.
  * <b>NOT_USED_FOR_PRODUCTION:</b> Subaccount is not used for production purposes.
  * <b>USED_FOR_PRODUCTION:</b> Subaccount is used for production purposes. 
  
  ```
  @assert.range : true
  usedForProduction : String enum {
    USED_FOR_PRODUCTION;
    NOT_USED_FOR_PRODUCTION;
  };
};

@description : 'Clone configuration of the subaccount.'
type Accounts.Service.anonymous.type0 : String;

@description : 'List of additional admins of the subaccount. You can add users only from the same user base as you (example: sap.default or custom identity provider). Do not add yourself as you are assigned by default. Enter inline as a valid JSON array. Specify the admins by user IDs for Neo subaccounts and e-mails for multi-environment subaccounts.'
type Accounts.Service.anonymous.type1 : String;

@description : `Additional admins of the directory. Applies only to directories that have the user authorization management feature enabled. Do not add yourself as you are assigned as a directory admin by default. 

Example: ["admin1@example.com", "admin2@example.com"]`
type Accounts.Service.anonymous.type2 : String;

@description : ```
<b>An array of a single enum or multiple enums representing the features to be enabled in the directory. The enums of the available features are:</b>
-\t<b>DEFAULT</b>: (Mandatory) All directories provide the following basic features: (1) Group and filter subaccounts for reports and filters, (2) monitor usage and costs on a directory level (costs only available for contracts that use the consumption-based commercial model), and (3) set custom properties and tags to the directory for identification and reporting purposes.
-\t<b>ENTITLEMENTS</b>: (Optional) Enables the assignment of a quota for services and applications to the directory from the global account quota for distribution to the subaccounts under this directory. 
-\t<b>AUTHORIZATIONS</b>: (Optional) Allows you to assign users as administrators or viewers of this directory. You must apply this feature in combination with the ENTITLEMENTS feature.


IMPORTANT: Your multi-level account hierarchy can have more than one directory enabled with user authorization and/or entitlement management; however, only one directory in any directory path can have these features enabled. In other words, other directories above or below this directory in the same path can only have the default features specified. If you are not sure which features to enable, we recommend that you set only the default features, and then add features later on as they are needed. 


<b>Valid values:</b> 

[DEFAULT]

[DEFAULT, ENTITLEMENTS]

[DEFAULT, ENTITLEMENTS, AUTHORIZATIONS]
```
type Accounts.Service.anonymous.type3 { };

@description : 'List of additional admins of the subaccount. You can add users only from the same user base as you (example: sap.default or custom identity provider). Do not add yourself as you are assigned by default. Enter inline as a valid JSON array. Specify the admins by user IDs for Neo subaccounts and e-mails for multi-environment subaccounts.'
type Accounts.Service.anonymous.type4 : String;

@description : ```
An array of a single enum or multiple enums representing the features to be enabled in the directory. The enums of the available features are:
-\tDEFAULT: (Mandatory) All directories have the following basic feature enabled. (1) Group and filter subaccounts for reports and filters, (2) monitor usage and costs on a directory level (costs only available for contracts that use the consumption-based commercial model), and (3) set custom properties and tags to the directory for identification and reporting purposes.
-\tENTITLEMENTS: (Optional) Allows the assignment of a quota for services and applications to the directory from the global account quota for distribution to the subaccounts under this directory. 
-\tAUTHORIZATIONS: (Optional) Allows the assignment of users as administrators or viewers of this directory. You must apply this feature in combination with the ENTITLEMENTS feature.


<b>Valid values:</b> 

[DEFAULT]

[DEFAULT, ENTITLEMENTS]

[DEFAULT, ENTITLEMENTS, AUTHORIZATIONS]
```
type Accounts.Service.anonymous.type5 { };

@description : 'GUIDs of the subaccounts to move.'
type Accounts.Service.anonymous.type6 : String;

@description : 'The features of parent entity of the subaccount.'
type Accounts.Service.anonymous.type7 { };

@description : 'Additional admins of the directory. Applies only to directories that have the user authorization management feature enabled. Do not add yourself as you are assigned as a directory admin by default. Example: ["admin1@example.com", "admin2@example.com"]'
type Accounts.Service.anonymous.type8 : String;

@description : ```
<b>An array of a single enum or multiple enums representing the features to be enabled in the directory. The enums of the available features are:</b>
-\tDEFAULT: (Mandatory) All directories provide the following basic features: (1) Group and filter subaccounts for reports and filters, (2) monitor usage and costs on a directory level (costs only available for contracts that use the consumption-based commercial model), and (3) set custom properties and tags to the directory for identification and reporting purposes. 
-\tENTITLEMENTS: (Optional) Enables the assignment of a quota for services and applications to the directory from the global account quota for distribution to the subaccounts under this directory. 
-\tAUTHORIZATIONS: (Optional) Allows you to assign users as administrators or viewers of this directory. You must apply this feature in combination with the ENTITLEMENTS feature.



<b>Valid values:</b> 

[DEFAULT]

[DEFAULT, ENTITLEMENTS]

[DEFAULT, ENTITLEMENTS, AUTHORIZATIONS]

In this call, you must set all the features that you want enabled in the directory, including those that are already enabled and which must remain enabled. If, for example, only the default features are currently enabled, you can specify either [DEFAULT, ENTITLEMENTS] or [DEFAULT, ENTITLEMENTS, AUTHORIZATIONS] to enable the additional directory features. To remove an already enabled feature, then omit it. For example, if all features were enabled in the directory [DEFAULT, ENTITLEMENTS, AUTHORIZATIONS] and you'd like to now remove user authorization management, then specify [DEFAULT, ENTITLEMENTS]. 

<br/>IMPORTANT: If you remove user authorization management, then any existing user assignments, role collections, and the tenant of the directory are automatically removed. You (the global account admin) still has access to everything under the directory. If you remove entitlement management, then the remaining quota in the directory is returned to the global account, while all subaccounts in the directory keep their assigned entitlement and quota assignments.ֿ

```
type Accounts.Service.anonymous.type9 { };

