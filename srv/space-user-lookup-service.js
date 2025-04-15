const cds = require('@sap/cds');
const axios = require('axios');

module.exports = async function () {
  this.on('GetUserGUIDByEmail', async req => {
    console.log("Received data:", req.data);
    const input = req.data.data || req.data;
    console.log("Extracted input:", input);
    
    const { userName, origin } = input;
    if (!userName || !origin) {
      req.error(400, "Missing required fields: 'userName' and/or 'origin'");
      return;
    }
    try {
      // Step 1: Retrieve an OAuth2 access token using client credentials.
      // These values can be stored in environment variables or a secure configuration file.
      const tokenServiceUrl = process.env.CF_TOKEN_SERVICE_URL || "https://0a2bf81dtrial.authentication.us10.hana.ondemand.com/oauth/token";
      const clientId = process.env.CF_CLIENT_ID || "sb-na-65847026-163b-4562-a579-d5d557967de7!a415807";
      const clientSecret = process.env.CF_CLIENT_SECRET || "08967bb4-064c-4c76-8dde-2f5e8424035f$gLFnNiC6LK4WuCJaURRI8mkOprAGsVJ59hnCLjmiuj0="; // Replace or secure this appropriately

      // Prepare data for token request (x-www-form-urlencoded)
      const tokenRequestData = "grant_type=client_credentials";

      const tokenResponse = await axios.post(tokenServiceUrl, tokenRequestData, {
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        auth: {
          username: clientId,
          password: clientSecret
        }
      });

      const accessToken = tokenResponse.data.access_token;
      console.log("🔑 Access Token received:", accessToken);

      // Step 2: Use the access token to call the CF API endpoint.
      const baseUrl = process.env.CF_API_URL || "https://api.cf.us10.hana.ondemand.com";
      const fullUrl = `${baseUrl}/v3/users?usernames=${encodeURIComponent(userName)}&origins=${encodeURIComponent(origin)}`;

      const response = await axios.get(fullUrl, {
        headers: {
          Authorization: `Bearer ${accessToken}`
        }
      });

      console.log("💡 CF API Response:", JSON.stringify(response.data, null, 2));

      // Assume the API returns a JSON object with an array of resources.
      if (response.data && response.data.resources && response.data.resources.length > 0) {
        const user = response.data.resources[0];
        return {
          guid: user.guid,
          userName: user.username,  // Double-check the property; sometimes it might be 'userName'
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
