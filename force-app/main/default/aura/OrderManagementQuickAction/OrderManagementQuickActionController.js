({
    navigateToLC : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();

        var pageReference = {
            type: 'standard__navItemPage',
            attributes: {
                apiName: "Order_Management"             },
            state: {
                c__refRecordId: component.get("v.recordId")
            }
        };
        component.set("v.pageReference", pageReference);
        const navService = component.find('navService');
        const pageRef = component.get('v.pageReference');
        const handleUrl = (url) => {
            window.open(url);
        };
        const handleError = (error) => {
            console.log(error);
        };
        navService.generateUrl(pageRef).then(handleUrl, handleError);
    } 
})
