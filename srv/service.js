const cds = require('@sap/cds');
const axios = require('axios');
const xsenv = require('@sap/xsenv');

module.exports = cds.service.impl(async function () {
    const { Subaccounts, Spaces } = this.entities;

    // Load credentials dynamically from bound service (e.g., XSUAA)
    // const services = xsenv.getServices({ xsuaa: { name: "ADMIN_ACCESS-auth" } });

    // console.log("XSUAA Services Credentials:", services)
    const accountServiceAPI = await cds.connect.to('account-service-api');
    const provisioningServiceAPI = await cds.connect.to('provisioning-service-api'); // currently 
    const serviceManagerAPI = await cds.connect.to('service-manager-api');
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
        // const { subaccountId } = req.data;

        // if (!subaccountId) {
        //     req.error(400, "subaccountId is required");
        //     return;
        // }

        try {

            const response = await serviceManagerAPI.get(`/v1/service_instances`);

            console.log("Response: ", response);
            if (!response) {
                throw new Error("Unexpected API response format");
            }
            spaces = [];
            results = [];
            response.items.forEach(element => {
                if (element.context?.space_name && !spaces.includes(element.context?.space_name)) {
                    results.push({
                        spaceId: element.context?.space_guid,
                        name: element.context?.space_name,
                        subaccountId: element.context?.subaccount_id
                    })
                    spaces.push(element.context?.space_name);
                }
            });
            return results;
        } catch (error) {
            console.error("Error fetching spaces:", error.message);
            throw new Error("Unable to retrieve spaces. Please try again later.");
        }
    });
});
