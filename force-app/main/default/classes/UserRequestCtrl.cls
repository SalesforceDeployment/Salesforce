public class UserRequestCtrl {
    public String idd;
    //public String salesforceBaseURL{get;set;}
    
    Public String getsalesforceBaseURL(){
        return URL.getSalesforceBaseUrl().toExternalForm();
    }
    
}