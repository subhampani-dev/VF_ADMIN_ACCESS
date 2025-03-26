const cds = require('@sap/cds');
const axios = require('axios');
const xsenv = require('@sap/xsenv');

module.exports = cds.service.impl(async function () {
    const { Subaccounts, Spaces } = this.entities;

    // Load credentials dynamically from bound service (e.g., XSUAA)
    // const services = xsenv.getServices({ xsuaa: { name: "ADMIN_ACCESS-auth" } });

    // console.log("XSUAA Services Credentials:", services)
    const accountServiceAPI = await cds.connect.to('account-service-api');
    async function getAccessToken() {
        try {
            const response = await axios.post(services.xsuaa.url + "/oauth/token", null, {
                auth: {
                    username: services.xsuaa.clientid,
                    password: services.xsuaa.clientsecret
                },
                params: { grant_type: "client_credentials" }
            });
            return response.data.access_token;
        } catch (error) {
            throw new Error("Failed to fetch access token: " + error.message);
        }
    }

    this.on('getSubaccounts', async () => {
        try {
            const response = await accountServiceAPI.get('/accounts/v1/subaccounts');

            console.log("Response: ", response);
            if (!response.value) {
                throw new Error("Unexpected API response format");
            }

            return response.value.map(acc => ({
                subaccountId: acc.guid,
                name: acc.displayName,
                region: acc.region
            }));
        } catch (error) {
            console.error("Error fetching subaccounts:", error.message);
            throw new Error("Unable to retrieve subaccounts. Please try again later.");
        }
    });

    this.on('getSpaces', async (req) => {
        const { subaccountId } = req.data;

        if (!subaccountId) {
            req.error(400, "subaccountId is required");
            return;
        }

        try {

            const response = await accountServiceAPI.get(`/accounts/v1/subaccounts/${subaccountId}`);

            console.log("Response: ", response);

            if (!response.value) {
                throw new Error("Unexpected API response format");
            }

            return response.value.map(space => ({
                spaceId: space.guid,
                name: space.name,
                subaccountId: subaccountId
            }));
        } catch (error) {
            console.error("Error fetching spaces:", error.message);
            throw new Error("Unable to retrieve spaces. Please try again later.");
        }
    });
});
