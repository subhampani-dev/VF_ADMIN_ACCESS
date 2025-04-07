const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  const scim = await cds.connect.to('SCIM_API');

  this.on('createUser', async (req) => {
    const { userName, emails = [], roles = [] } = req.data;
    const payload = {
      userName,
      emails: emails.map(e => ({ value: e.value, type: e.type || "work" })),
      groups: roles.map(r => ({ value: r })) // Assuming roles map to role collections
    };

    try {
      const result = await scim.run({ method: 'POST', path: '/Users', data: payload });
      return `User created: ${result.id}`;
    } catch (err) {
      req.error(500, `Create failed: ${err.message}`);
    }
  });

  this.on('getUsers', async (req) => {
    try {
      const result = await scim.run({ method: 'GET', path: '/Users' });
      return result?.Resources?.map(u => ({
        id: u.id,
        userName: u.userName,
        emails: u.emails || [],
        roles: u.groups?.map(g => g.display) || []
      })) || [];
    } catch (err) {
      req.error(500, `Get failed: ${err.message}`);
    }
  });

  this.on('updateUser', async (req) => {
    const { ID, userName, emails = [], roles = [] } = req.data;
    const payload = {
      userName,
      emails: emails.map(e => ({ value: e.value, type: e.type || "work" })),
      groups: roles.map(r => ({ value: r }))
    };

    try {
      await scim.run({ method: 'PUT', path: `/Users/${ID}`, data: payload });
      return `User updated: ${ID}`;
    } catch (err) {
      req.error(500, `Update failed: ${err.message}`);
    }
  });

  this.on('deleteUser', async (req) => {
    const { ID } = req.data;

    try {
      await scim.run({ method: 'DELETE', path: `/Users/${ID}` });
      return `User deleted: ${ID}`;
    } catch (err) {
      req.error(500, `Delete failed: ${err.message}`);
    }
  });
});