public without sharing class SummaryController {
    
    public List<Patient_Request__c> summaryData{get;set;}
    public List<PatientRequestWrapper> patientParameterData1{get;set;}
    public List<Patient_Request_Eligibility__c> patientEligibilityData1{get;set;}
    public List<Patient_Request_Eligibility__c> patientEligibilityData2{get;set;}
    public List<Patient_Dosage_Request__c> patientDosageData1{get;set;}
    public List<Patient_Request_Parameters__c> patientParameterDataOthers{get;set;}
    public String currentRecordId {get;set;}  
    public Boolean isPii {get;set;}
    public Boolean isTC {get;set;}
    public Boolean isReviewer {get;set;}
    public List<Project_Country_Regulatory_Consent__c> tcData{get;set;}
    public List<Project_Country_Regulatory_Consent__c> tcRest{get;set;}
    public Boolean isStep7 {get;set;}
    public String projectCountry {get;set;}
    public String projectGroup {get;set;}
    public List<Patient_Request_Supporting__c> eligibilitySupporting{get;set;}
    public string jobId{get;set;}
    public static string currentJobId;
    
    public SummaryController() {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('currentRecordId');
        isPii= Boolean.valueOf(ApexPages.CurrentPage().getparameters().get('isPii'));
        isTC = Boolean.valueOf(ApexPages.CurrentPage().getparameters().get('isTC'));
        projectCountry = ApexPages.CurrentPage().getparameters().get('projectCountry');
        projectGroup = ApexPages.CurrentPage().getparameters().get('projectGroup');
        isStep7 = Boolean.valueOf(ApexPages.CurrentPage().getparameters().get('isStep7'));
        isReviewer = Boolean.valueOf(ApexPages.CurrentPage().getparameters().get('isReviewer'));
        system.debug('isPii==>'+isPii);
        system.debug('isTC==>'+isTC);
        system.debug('isReviewer==>'+isReviewer);
        List<PatientRequestWrapper> basicParameters = new List<PatientRequestWrapper> ();
        List<Patient_Request_Parameters__c> otherParameters = new List<Patient_Request_Parameters__c> ();
        List<Patient_Request_Eligibility__c> inclusionEligibilities = new List<Patient_Request_Eligibility__c> ();
        List<Patient_Request_Eligibility__c> exclusionEligibilities = new List<Patient_Request_Eligibility__c> ();
        if(String.isNotBlank(currentRecordId)) {
            summaryData = [SELECT Id, Name, Consent_Provided__c, PatientId__c, Institutation__r.Name, Project_Group__r.Name, Project_Country_Indication__r.Indication__r.Indication_Name__c, Patient__r.Name, On_Behalf_Of__r.Contact.Name, On_Behalf_Of__r.Contact.Title, On_Behalf_Of__r.Contact.Department, On_Behalf_Of__r.Contact.Phone, On_Behalf_Of__r.Contact.Email, DeliveryAddressContactName__c, DeliveryAddressHospitalName__c,  DeliveryAddress__c, DeliveryAddressCountry__c, DeliveryAddressPostCode__c, DeliveryContactTelephone__c, DeliveryContactOutOfHoursNumber__c, DeliveryContactFax__c, DeliveryContactEmail__c, DeliveryNote__c FROM Patient_Request__c WHERE Id =:currentRecordId];
            for(Patient_Request_Parameters__c patientRec: [SELECT Id, Name, Patient__c, Project_Country_Patient_Parameter__r.Parameter_Name__c, Patient_Parameter_Response__c FROM Patient_Request_Parameters__c WHERE Patient_Request__c=:currentRecordId]) {
                if((isReviewer == false && patientRec.Project_Country_Patient_Parameter__r.Parameter_Name__c.equalsIgnoreCase('Initial(s)')) || 
                   patientRec.Project_Country_Patient_Parameter__r.Parameter_Name__c.equalsIgnoreCase('Date Of Birth') || 
                   patientRec.Project_Country_Patient_Parameter__r.Parameter_Name__c.equalsIgnoreCase('Gender')) {
                       PatientRequestWrapper wrapperObj = new PatientRequestWrapper ();
                       wrapperObj.parameterName = patientRec.Project_Country_Patient_Parameter__r.Parameter_Name__c;
                       if(patientRec.Project_Country_Patient_Parameter__r.Parameter_Name__c.equalsIgnoreCase('Date Of Birth')) {
                           Date newDate = Date.valueOf(patientRec.Patient_Parameter_Response__c);
                           String formattedDate = DateTime.newInstance(newDate.year(),newDate.month(),newDate.day()).format('dd MMM yyyy');
                           wrapperObj.parameterResponse = formattedDate;
                       } else {
                           wrapperObj.parameterResponse = patientRec.Patient_Parameter_Response__c;
                       }
                       basicParameters.add(wrapperObj);
                   } else {
                       otherParameters.add(patientRec);
                   }
            }
            system.debug('basicParameters==>'+basicParameters);
            if(!basicParameters.isEmpty()) {
                patientParameterData1 = basicParameters;
            }
            if(!otherParameters.isEmpty()) {
                patientParameterDataOthers = otherParameters;
            }
            for (Patient_Request_Eligibility__c eligibilityRec: [SELECT Id, Name, Project_Country_Eligibility__r.Question__c, Patient_Eligibility_Response__c, Project_Country_Eligibility__r.Eligibility_Type__c FROM Patient_Request_Eligibility__c WHERE Patient_Request__c=:currentRecordId]) {
                if(eligibilityRec.Project_Country_Eligibility__r.Eligibility_Type__c =='Inclusion Criteria') {
                    inclusionEligibilities.add(eligibilityRec);
                }
                if(eligibilityRec.Project_Country_Eligibility__r.Eligibility_Type__c =='Exclusion Criteria') {
                    exclusionEligibilities.add(eligibilityRec);
                }
            }
            if(!inclusionEligibilities.isEmpty()) {
                patientEligibilityData1 = inclusionEligibilities;
            }
            if(!exclusionEligibilities.isEmpty()) {
                patientEligibilityData2 = exclusionEligibilities;
            }
            patientDosageData1 = [SELECT Id, Name, Dosing_Details__r.Strength__c, Quantity__c  FROM Patient_Dosage_Request__c WHERE Patient_Access_Request__c=:currentRecordId];
        }
        if(projectCountry!=null || projectGroup!=null) {
            tcData = [SELECT Id, Project_Country__c, Project_Country__r.Project__r.Additional_Product_Information__c,  Project_Country__r.Project__r.Project_Status__c, Sequence_Order__c, Consent_Title__c, Consent_Description__c, Project_Country__r.Country__c, Project_Country__r.Project__r.Project_Group__c FROM Project_Country_Regulatory_Consent__c WHERE Project_Country__r.Country__c=: projectCountry AND Project_Country__r.Project__r.Project_Group__c=:projectGroup AND Project_Country__r.Project__r.Project_Status__c='Live' AND Sequence_Order__c!=2];
            tcRest = [SELECT Id, Project_Country__c, Project_Country__r.Project__r.Additional_Product_Information__c,  Project_Country__r.Project__r.Project_Status__c, Sequence_Order__c, Consent_Title__c, Consent_Description__c, Project_Country__r.Country__c, Project_Country__r.Project__r.Project_Group__c FROM Project_Country_Regulatory_Consent__c WHERE Project_Country__r.Country__c=: projectCountry AND Project_Country__r.Project__r.Project_Group__c=:projectGroup AND Project_Country__r.Project__r.Project_Status__c='Live' AND Sequence_Order__c=2];
            eligibilitySupporting = [SELECT Id, Country_Supporting_Info_Requrement__r.Parameter_Name__c, Patient_Request_Supporting_Response__c FROM Patient_Request_Supporting__c WHERE Patient_Request__c=:currentRecordId];
        }
        system.debug('tcData==>'+tcData);
    }  
    public List<Patient_Request_Supporting__c> getEligibilitySupportingData1() {
        return eligibilitySupporting;
    }    
    public List<Project_Country_Regulatory_Consent__c> getTcData1() {
        return tcData;
    }
    public List<Project_Country_Regulatory_Consent__c> getTcRest1() {
        return tcRest;
    }    
    public List<Patient_Request__c> getPhyData() {
        return summaryData;
    }
    public List<PatientRequestWrapper> getpatientParameterData() {
        return patientParameterData1;
    }
    public List<Patient_Request_Parameters__c> getPatientParameterOthers() {
        return patientParameterDataOthers;
    }
    public List<Patient_Request_Eligibility__c> getpatientEligibilityData() {
        return patientEligibilityData1;
    }
    public List<Patient_Request_Eligibility__c> getpatientEligibilityExclusionData() {
        return patientEligibilityData2;
    }
    public List<Patient_Dosage_Request__c> getpatientDosageData() {
        return patientDosageData1;
    }
    public Boolean getPii() {
        return isPii;
    }
    public Boolean getTC() {
        return isTC;
    }
    @AuraEnabled
    public static Boolean login(String username, String password) {
        String domain = system.label.SalesforceDomain;
        Boolean isAuthenticated = false;         
        try{
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
            String sessionId = getValueFromXMLString(responseBody, 'sessionId');
            if(string.isNotBlank(sessionId)) {
                isAuthenticated = true;                 
            }else{
                isAuthenticated = false;
            }
        }
        catch(System.Exception ex){
            isAuthenticated = false;
        }
        system.debug('response-->'+isAuthenticated);
        return isAuthenticated;
    }
    public static string getValueFromXMLString(string xmlString, string keyField){
        String xmlKeyValue = '';
        if(xmlString.contains('<' + keyField + '>')){
            try{
                xmlKeyValue = xmlString.substring(xmlString.indexOf('<' + keyField + '>')+keyField.length() + 2, xmlString.indexOf('</' + keyField + '>'));   
            }catch (exception e){
                
            }            
        }
        return xmlKeyValue;
    }   
    @AuraEnabled
    public static void generatePdf(String jsonString) {
        system.debug('json 168-->'+jsonString);
        sendPDF(jsonString);
    }
    @future(callout=true)
    public static void sendPDF(String jsonString) {
        system.debug('json-->'+jsonString);
        string username = system.label.SalesforceUsername;
        string password = system.label.SalesforcePassword;
        String domain = system.label.SalesforceDomain;
        
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
        String sessionId = getValueFromXMLString(responseBody, 'sessionId');
        if(string.isNotBlank(sessionId)) {
            string baseUrl = system.URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/CommunityLoginAPI';
            PageReference pdfPage = new PageReference(baseUrl);
            pdfPage.getParameters().put('jsonString', jsonString);
            HttpRequest request1 = new HttpRequest();
            request1.setEndpoint(pdfPage.getUrl());
            request1.setMethod('GET');
            request1.setHeader('Authorization', 'OAuth ' + sessionId);
            HttpResponse res = new Http().send(request1);
        }
    }
    @AuraEnabled
    public static string getDocumentId(String patientRequestId) {
        List<String> statusList = new List<String> {'Aborted', 'Completed', 'Failed'};
            try {
                List<AsyncApexJob> asyncJobList = [SELECT Id, Status, ApexClassId, ApexClass.Name FROM AsyncApexJob WHERE ApexClass.Name = 'SummaryOfApplicationQueueable' AND status NOT IN: statusList ORDER BY createdDate desc LIMIT 1];
                system.debug('asyncJobList-->'+asyncJobList.size());
                if(asyncJobList.size() == 0 && String.isNotBlank(patientRequestId)) {
                    List<ContentDocumentLink> contentDocList = [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersion.Document_Type__c, ContentDocument.CreatedDate FROM ContentDocumentLink WHERE (LinkedEntityId=:patientRequestId AND LinkedEntityId!= null AND ContentDocument.LatestPublishedVersion.Document_Type__c=null) ORDER BY ContentDocument.CreatedDate DESC LIMIT 1];
                    if(!contentDocList.isEmpty()) {
                        return contentDocList.get(0)?.ContentDocumentId;
                    }
                } 
            } catch(Exception ex) {
                system.debug('Exception-->'+ex.getMessage()+'at Line No.'+ex.getLineNumber());
                throw ex;               
            }
        return null;
    }
    @AuraEnabled
    public static void deleteDocument(String documentId) {
        if(String.isNotBlank(documentId)) {
            List<ContentDocument> contentDocList = [SELECT Id FROM ContentDocument where Id=:documentId];
            if(!contentDocList.isEmpty()) {
                delete contentDocList;
            }
        }
    }
    public class PatientRequestWrapper {
        public String parameterName {get; set;}
        public String parameterResponse {get; set;}
    }
}