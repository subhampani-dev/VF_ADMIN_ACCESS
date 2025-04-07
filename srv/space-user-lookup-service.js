const cds = require('@sap/cds');

module.exports = async function () {
  const cf = await cds.connect.to('CF_API');

  this.on('GetUserGUIDByEmail', async req => {
    const { userName, origin } = req.data;
  
    try {
      const response = await cf.run({
        method: 'GET',
        path: `/v3/users?usernames=${encodeURIComponent(userName)}&origins=${origin}`
      });
  
      console.log("💡 CF API Response:", JSON.stringify(response, null, 2));
  
      if (response && response.resources && response.resources.length > 0) {
        const user = response.resources[0];
        return {
          guid: user.guid,
          userName: user.username,
          origin: user.origin
        };
      } else {
        req.error(404, `User '${userName}' with origin '${origin}' not found.`);
      }
  
    } catch (error) {
      console.error('🔥 Error fetching user GUID:', error);
      req.error(500, `Failed to fetch user GUID: ${error.message}`);
    }
  });
};