const cds = require('@sap/cds');
const { executeHttpRequest } = require ('@sap-cloud-sdk/http-client');

module.exports = cds.service.impl(async function (){
    this.on('getSpacesFromSubaccount',async(req)=>{
        try{
            const {subaccountID} = Request.data;
            if (!subaccountID) throw new Error("SubAccount ID is required");

            const response = await executeHttpRequest({destinationName : 'BTP_Management_API'},
                {method : "GET",
                url : 'v1/subaccounts/${subaccountID}/spaces',
                Headers : {'Accept':'application/json'}}
            );
            return response.data.map(space =>({
                spaceId : space.guid,
                name : space.name,
                Org_ID : space.organization_guid
            })); 
        }
        catch (error){
            console.log("Error fetching spaces data :" +error.response?.data || error.message);
            req.error(500,'Failed to fetch the space details.')
        }
    });
});  