@isTest
public class SummaryOfApplicationQueueableTest {
 @testSetup 
    static void setup() {
        Integer numberOfrecords = 1;
        
        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        insert createAccountsList;
        
        List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        insert contacts;
        
        List<Institution_Additional_Address__c> institutionAdditionalAddressList =  UtilData.createInstitutionAddress(createAccountsList);
        insert institutionAdditionalAddressList;
        
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
        insert projects;
        
        List<Indication__c> indications = UtilData.createIndications(projects);
        insert indications; 
        
        List<Project_Country__c> projCountries = UtilData.createProjectCountry(projects);
        insert projCountries;
        
        List<Project_Country_Indication__c > projectIndicationCountries = UtilData.createProjectCountryIndications(indications,projCountries);
        insert projectIndicationCountries;
        
        List<Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentList = UtilData.createProjectCountryRegulatoryConsent(projCountries);
        insert ProjectCountryRegulatoryConsentList;
        
        List<Project_Country_Patient_Parameter__c> projCountryPatientParameterList = UtilData.createProjectCountryPatientParameter(projCountries);
        projCountryPatientParameterList[0].First__c = true;
        insert projCountryPatientParameterList;       
        
        List<Project_Country_Supporting_Information__c> projectSupportingInfo = UtilData.createProjSuppInfo(projCountries);
        projectSupportingInfo[0].First__c = true;
        insert projectSupportingInfo;
        
        List<Project_Country_Eligibility__c> projectCountryEligibilityList = UtilData.createProjectCountryEligibilities(projCountries);
        insert projectCountryEligibilityList;
        
        Patient__c patient = UtilData.createPatient(contacts[0].id);
        insert patient;
        
        Patient_Request__c patientRequest = UtilData.createPatientRequest();
        insert patientRequest;
        
        Patient_Request_Parameters__c PatientRequestParameters = UtilData.createPatientRequestParameters(patient.Id, projCountryPatientParameterList[0].id, patientRequest.Id, ProjGroups[0].id);
        insert PatientRequestParameters;
    }  
    @isTest
    static void CommunityTest() {
        Patient_Request__c patientRequest = [select Id FROM Patient_Request__c limit 1];
        Project_Country__c pc = [select Id, Project__r.Project_Group__c FROM Project_Country__c limit 1];
        Project_Country_Eligibility__c eligibilities = [SELECT Id FROM Project_Country_Eligibility__c LIMIT 1];
        String jsonString = '{"patientReqId":"'+patientRequest.Id+'", "isStep7":"true", "isPii":"true", "isTC":"true", "projectGroup":"'+pc.Project__r.Project_Group__c+'", "projectCountry":"'+pc.Id+'"}';
        RestContext.request = new RestRequest();
        RestContext.request.params.put('jsonString', jsonString);
        PageReference pageRef = Page.SummaryOfApplication;
        // Add parameters to page URL
        pageRef.getParameters().put('currentRecordId', patientRequest.id);
        pageRef.getParameters().put('isPii', 'false');
        pageRef.getParameters().put('isTC', 'false');
        pageRef.getParameters().put('projectCountry', pc.Id);
        pageRef.getParameters().put('projectGroup', pc.Project__r.Project_Group__c);
        pageRef.getParameters().put('isStep7', 'false');
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new CommunityCalloutMock());  
        Test.startTest();
        ID jobID = System.enqueueJob(new SummaryOfApplicationQueueable(jsonString));
        Test.stopTest();
    }
    public class CommunityCalloutMock implements HttpCalloutMock {
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('Success');
            return res;
        }
    }  
}