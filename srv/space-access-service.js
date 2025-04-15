const cds = require('@sap/cds');
const axios = require('axios');
const qs = require('querystring');

module.exports = async function () {
  // Hardcoded credentials and URLs (for testing purposes).
  // In production, these should be stored securely (e.g., as environment variables).
  const CLIENT_ID = 'sb-na-65847026-163b-4562-a579-d5d557967de7!a415807';
  const CLIENT_SECRET = '08967bb4-064c-4c76-8dde-2f5e8424035f$gLFnNiC6LK4WuCJaURRI8mkOprAGsVJ59hnCLjmiuj0=';
  const TOKEN_SERVICE_URL = 'https://0a2bf81dtrial.authentication.us10.hana.ondemand.com/oauth/token';
  const CF_API_URL = 'https://api.cf.us10.hana.ondemand.com';

  // Helper function to obtain an access token via OAuth2 client credentials flow.
  async function getAccessToken() {
    try {
      // Prepare request data. Optionally, include a scope if required.
      const tokenRequestData = qs.stringify({ grant_type: 'client_credentials' });
      const basicAuth = Buffer.from(`${CLIENT_ID}:${CLIENT_SECRET}`).toString('base64');
      console.log("Basic Auth header:", basicAuth);
      const tokenResp = await axios.post(TOKEN_SERVICE_URL, tokenRequestData, {
        headers: { 
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': `Basic ${basicAuth}`
        }
      });
      return tokenResp.data.access_token;
    } catch (err) {
      console.error("Error retrieving access token:", err.response ? err.response.data : err.message);
      throw new Error("Access token retrieval failed");
    }
  }

  // Function to assign a role (or role binding) using the CF API.
  const assignRole = async (req, roleType) => {
    const input = req.data.data || req.data;
    const { userGUID, spaceGUID } = input;

    if (!userGUID || !spaceGUID) {
      req.error(400, "Missing required fields: 'userGUID' and/or 'spaceGUID'");
      return;
    }
    
    try {
      const accessToken = await getAccessToken();
      // Use the correct endpoint for role assignments.
      const roleAssignmentUrl = `${CF_API_URL}/v3/role_assignments`;

      // Build the payload using the CF expected structure.
      // Note: The CF v3 API expects the "actor" relationship (not “user”) for the user GUID.
      const payload = {
        type: roleType, // e.g., "space_developer", "space_auditor", or "space_manager"
        relationships: {
          actor: { data: { guid: userGUID } },
          space: { data: { guid: spaceGUID } }
        }
      };

      console.log("Posting to:", roleAssignmentUrl, "with payload:", JSON.stringify(payload));

      const response = await axios.post(roleAssignmentUrl, payload, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${accessToken}`
        }
      });
      
      console.log("CF API Response:", response.data);
      return { message: `✅ ${roleType} role assigned to user ${userGUID} in space ${spaceGUID}` };
      
    } catch (err) {
      console.error("Error in role assignment:", err.response ? err.response.data : err.message);
      req.error(500, `❌ Failed to assign ${roleType}: ${err.response && err.response.data ? JSON.stringify(err.response.data) : err.message}`);
    }
  };

  // Register the actions for each role.
  this.on('AssignSpaceDeveloper', req => assignRole(req, 'space_developer'));
  this.on('AssignSpaceAuditor', req => assignRole(req, 'space_auditor'));
  this.on('AssignSpaceManager', req => assignRole(req, 'space_manager'));
};
