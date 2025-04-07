const cds = require('@sap/cds');
const axios = require('axios');
const xsenv = require('@sap/xsenv');
const { getDestinationFromDestinationService } = require('@sap-cloud-sdk/connectivity')
module.exports = cds.service.impl(async function () {
    const { Subaccounts, Spaces } = this.entities;

    // Load credentials dynamically from bound service (e.g., XSUAA)
    //const services = xsenv.getServices({ xsuaa: { name: "ADMIN_ACCESS-auth" } });

    // console.log("XSUAA Services Credentials:", services)

    /*
    * Cloud Management service - I used a plan of "central viewer" for creating this service instance 
    * it accepts - client credentials as grant type - read only authorization of api - can't able to do all CRUD
    * API Documentation: https://api.sap.com/api/APIAccountsService/overview
    * sap help docs: https://help.sap.com/docs/btp/sap-business-technology-platform/sap-cloud-management-service-service-plans
    *                https://help.sap.com/docs/btp/sap-business-technology-platform/account-administration-using-apis
    */
    const accountServiceAPI = await cds.connect.to('account-service-api');
    const provisioningServiceAPI = await cds.connect.to('provisioning-service-api'); // currently need to R&D about this.


    /*
    * service manager api - only created for this subaccount 0a2bf81dtrial with spaces of dev in cloud foundry
    * so - now only we can retrieve the spaces details of this specific subaccount
    * API Documentation: https://api.sap.com/api/APIServiceManager/overview
    * sap help docs: https://help.sap.com/docs/service-manager/sap-service-manager/working-with-sap-service-manager-apis
    */
    const serviceManagerAPI = await cds.connect.to('service-manager-api');
    // async function getAccessToken() {
    //     try {
    //         const response = await axios.post(services.xsuaa.url + "/oauth/token", null, {
    //             auth: {
    //                 username: services.xsuaa.clientid,
    //                 password: services.xsuaa.clientsecret
    //             },
    //             params: { grant_type: "client_credentials" }
    //         });
    //         return response.data.access_token;
    //     } catch (error) {
    //         throw new Error("Failed to fetch access token: " + error.message);
    //     }
    // }

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

        // now only we can retrieve the spaces details of this subaccount because of service manager instance available only in this subaccount
        try {
            const response = await serviceManagerAPI.get(`/v1/service_instances`);

            console.log("Response: ", response);
            if (!response) {
                throw new Error("Unexpected API response format");
            }
            const spaces = [];
            const results = [];
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

    this.on('getSpacesPSAPI', async (req) => {
        try {
            const accessTokenData = await getAccessTokenforPSAPI();
            const accessToken = accessTokenData.authTokens[0].value; // Ensure authTokens is correctly structured
            console.log("Token: ", accessToken);

            // Correcting headers and request format
            const response = await provisioningServiceAPI.get('/provisioning/v1/environments', {
                headers: {
                    Authorization: `Bearer ${accessToken}`
                }
            });

            return response.data; // Ensure you're returning the correct part of the response object
        } catch (error) {
            console.error("Error fetching spaces from Provisioning Service API: ", error);
            throw error;
        }
    });

    // Function to fetch access token
    async function getAccessTokenforPSAPI() {
        try {
            const destinationProvisionServiceAPI = await getDestinationFromDestinationService({
                destinationName: 'provisioning-service-api'
            });
            return destinationProvisionServiceAPI;
        } catch (error) {
            console.error("Error fetching destination details: ", error);
            throw error;
        }
    }

});
