public without sharing class UserAuthentication {
    @InvocableMethod(label='Check User Authentication' description='Return true/false value of user authentication')
    public static List<Boolean> checkUserAuthentication(List<InputVariable> userInput){
        String userName = userInput[0].userName;//'vineet.saxena@bionicalemas.com.bemasdev';
        String userPassword = userInput[0].userPassword;//'aarush2610';
        
        //List<Boolean> result = authenticateUserDetails(userName, userPassword);
        system.debug('UserInfo.getOrganizationId()  => ' + UserInfo.getOrganizationId()); 
        
        Boolean IsAuthenticated = verifyLoginfromFlow(userName, userPassword);
        List<Boolean> result = new List<Boolean>();
        result.add(IsAuthenticated);
        return result;
    }
    public class InputVariable{
        @InvocableVariable
        public String userName;
        @InvocableVariable
        public String userPassword;
    }
    
    public class ReturnVariable{
        @InvocableVariable
        public boolean isAuthenticated;
        
    }
    
   @AuraEnabled
    public static Boolean login(String username, String password) {
        String domain = system.label.SalesforceDomain;
         Boolean isAuthenticated = false;
        if(password.contains('&')) {
           password = password.replace('&', '&amp;');
        }
        if(password.contains('<')) {
            password = password.replace('<', '&lt;');
        }
        if(password.contains('>')) {
            password = password.replace('>', '&gt;');
        }
        if(password.contains('\'')) {
            password = password.replace('\'', '&apos;');
        }
        if(password.contains('"')) {
            password = password.replace('"', '&quot;');
        }
            string loginXML = '<?xml version="1.0" encoding="utf-8"?>';  
            loginXML+= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:enterprise.soap.sforce.com" xmlns:sobject="urn:sobject.enterprise.soap.sforce.com">';
            loginXML += '<soapenv:Header>';  
            loginXML += '<urn:LoginScopeHeader>';  
            loginXML += '<urn:organizationId>'+ UserInfo.getOrganizationId() +'</urn:organizationId>';  
            loginXML += '</urn:LoginScopeHeader>';  
            loginXML += '</soapenv:Header>';  
            loginXML += '<soapenv:Body>'; 
            loginXML += '<urn:login>';
            loginXML += '<urn:username>'+ username +'</urn:username>';
            loginXML += '<urn:password>'+ password +'</urn:password>';
            loginXML += '</urn:login>'; 
            loginXML += '</soapenv:Body>';  
            loginXML += '</soapenv:Envelope>';
            HttpRequest request = new HttpRequest();
            string apiVersion = '47.0';
            string endpoint = 'https://'+domain+'.salesforce.com/services/Soap/c/'+apiVersion;
            request.setEndpoint(endpoint);
            request.setTimeout(60000); 
            request.setMethod('POST');
            request.setHeader('SOAPAction', 'login');
            request.setHeader('Accept','text/xml');
            request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            request.setBody(loginXML);       
            HttpResponse response = new Http().send(request);
             
            String responseBody = response.getBody();
            system.debug('inside response-->'+responseBody);
            String sessionId = getValueFromXMLString(responseBody, 'sessionId');
            if(string.isNotBlank(sessionId)) {
                isAuthenticated = true;                 
            } else {
                 isAuthenticated = false;
            }
        system.debug('response-->'+isAuthenticated);
        return isAuthenticated;
    }
    
    public static Boolean verifyLoginfromFlow(String username, String password) {
        String domain = system.label.SalesforceDomain;
         Boolean isAuthenticated = false;
        if(password.contains('&')) {
           password = password.replace('&', '&amp;');
        }
        if(password.contains('<')) {
            password = password.replace('<', '&lt;');
        }
        if(password.contains('>')) {
            password = password.replace('>', '&gt;');
        }
        if(password.contains('\'')) {
            password = password.replace('\'', '&apos;');
        }
        if(password.contains('"')) {
            password = password.replace('"', '&quot;');
        }
      //  try {
            string loginXML = '<?xml version="1.0" encoding="utf-8"?>';  
            loginXML+= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:enterprise.soap.sforce.com" xmlns:sobject="urn:sobject.enterprise.soap.sforce.com">';
            loginXML += '<soapenv:Header>';  
            loginXML += '<urn:LoginScopeHeader>';  
            loginXML += '<urn:organizationId>'+ UserInfo.getOrganizationId() +'</urn:organizationId>';  
            loginXML += '</urn:LoginScopeHeader>';  
            loginXML += '</soapenv:Header>';  
            loginXML += '<soapenv:Body>'; 
            loginXML += '<urn:login>';
            loginXML += '<urn:username>'+ username +'</urn:username>';
            loginXML += '<urn:password>'+ password +'</urn:password>';
            loginXML += '</urn:login>'; 
            loginXML += '</soapenv:Body>';  
            loginXML += '</soapenv:Envelope>';
            HttpRequest request = new HttpRequest();
            string apiVersion = '47.0';
            string endpoint = 'https://'+domain+'.salesforce.com/services/Soap/c/'+apiVersion;
            request.setEndpoint(endpoint);
            request.setTimeout(60000); 
            request.setMethod('POST');
            request.setHeader('SOAPAction', 'login');
            request.setHeader('Accept','text/xml');
            request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            request.setBody(loginXML);       
            HttpResponse response = new Http().send(request);
             
            String responseBody = response.getBody();
            system.debug('inside response-->'+responseBody);
            String sessionId = getValueFromXMLString(responseBody, 'sessionId');
            if(string.isNotBlank(sessionId)) {
                isAuthenticated = true;                 
            } else {
                 isAuthenticated = false;
            }
        //}
        //catch(System.Exception ex) {
          //  system.debug('exception-->'+ex.getMessage()+'line-->'+ex.getLineNumber());
            // isAuthenticated = false;
        //}
        system.debug('response-->'+isAuthenticated);
        return isAuthenticated;
    }
     
    /*
* Get XML tag value from XML string
* @param xmlString : String XML
* @param keyField : XML key tag
* @return String : return XML tag key value
*/
    public static string getValueFromXMLString(string xmlString, string keyField){
        String xmlKeyValue = '';
        if(xmlString.contains('<' + keyField + '>')){
            try {
                xmlKeyValue = xmlString.substring(xmlString.indexOf('<' + keyField + '>')+keyField.length() + 2, xmlString.indexOf('</' + keyField + '>'));   
            } catch (exception e){
                 
            }            
        }
        return xmlKeyValue;
    }
}