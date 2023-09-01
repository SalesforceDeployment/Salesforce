public class salesforceBaseRecordUrlCtrl {
    public string recordId{get;set;}
    
    public string recordURL{get;set;}
    public string portalBaseURL{get;set;}
                      
    public salesforceBaseRecordUrlCtrl(){
        getRecordIdURL();
        getPortalBaseURL();
    }
                      
    public String getRecordIdURL(){
        /*URL.getSalesforceBaseUrl().toExternalForm()+*/ 
        recordURL = URL.getSalesforceBaseUrl().toExternalForm();
        return recordURL;
    }
    
    public String getPortalBaseURL(){
        portalBaseURL = System.Label.Partner_Community_URL + '/user-email-verfication?email=call.bijay1@gmail.com';
        return portalBaseURL;
    }
}