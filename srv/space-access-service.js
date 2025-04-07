const cds = require('@sap/cds');

module.exports = async function () {
  const cf = await cds.connect.to('CF_API');

  const assignRole = async (req, roleType) => {
    const { userGUID, spaceGUID } = req.data;

    try {
      await cf.run({
        method: 'POST',
        path: '/v3/roles',
        data: {
          type: roleType,
          relationships: {
            user: { data: { guid: userGUID } },
            space: { data: { guid: spaceGUID } }
          }
        }
      });

      // ✅ Return matching the RoleAssignmentResult type
      return { message: `✅ ${roleType} role assigned to user ${userGUID} in space ${spaceGUID}` };

    } catch (err) {
      console.error(err);
      req.error(500, `❌ Failed to assign ${roleType}: ${err.message}`);
    }
  };

  this.on('AssignSpaceDeveloper', req => assignRole(req, 'space_developer'));
  this.on('AssignSpaceAuditor', req => assignRole(req, 'space_auditor'));
  this.on('AssignSpaceManager', req => assignRole(req, 'space_manager'));
};