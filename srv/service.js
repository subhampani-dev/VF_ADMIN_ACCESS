const cds = require('@sap/cds');
const axios = require('axios');
const xsenv = require('@sap/xsenv');

module.exports = cds.service.impl(async function () {
    const { Subaccounts, Spaces } = this.entities;

    // Load credentials dynamically from bound service (e.g., XSUAA)
    const services = xsenv.getServices({ xsuaa: { name: "ADMIN_ACCESS-auth" } });

    async function getAccessToken() {
        const response = await axios.post(services.uaa.url + "/oauth/token", null, {
            auth: {
                username: services.uaa.clientid,
                password: services.uaa.clientsecret
            },
            params: { grant_type: "client_credentials" }
        });
        return response.data.access_token;
    }

    this.on('getSubaccounts', async () => {
        const accessToken = await getAccessToken();

        const response = await axios.get('https://accounts.cloud.sap/api/accounts/v1/subaccounts', {
            headers: { Authorization: `Bearer ${accessToken}` }
        });

        return response.data.value.map(acc => ({
            subaccountId: acc.guid,
            name: acc.displayName,
            region: acc.region
        }));
    });

    this.on('getSpaces', async (req) => {
        const { subaccountId } = req.data;

        if (!subaccountId) {
            req.error(400, "subaccountId is required");
            return;
        }

        const accessToken = await getAccessToken();

        const response = await axios.get(`https://accounts.cloud.sap/api/accounts/v1/subaccounts/${subaccountId}/spaces`, {
            headers: { Authorization: `Bearer ${accessToken}` }
        });

        return response.data.value.map(space => ({
            spaceId: space.guid,
            name: space.name,
            subaccountId: subaccountId
        }));
    });
});