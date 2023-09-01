/*********************************************************************************************************************
ClassName SummaryControllerTest
Purpose: This is a test class used to test the DynamicQuestionsController functionality.
AUTHOR : Nidhi Chouksey
Date : 08-July-2023
********************************************************************************************************************/
@isTest
public class SummaryControllerTest {
    
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
    public static testMethod void testSummaryController() {
        Patient_Request__c patientRequest = [select Id FROM Patient_Request__c limit 1];
        Project_Country__c pc = [select Id, Project__c, Project__r.Project_Group__c FROM Project_Country__c limit 1];
        Project_Country_Eligibility__c eligibilities = [SELECT Id FROM Project_Country_Eligibility__c LIMIT 1];
        PageReference pageRef = Page.SummaryOfApplication;
        // Add parameters to page URL
        pageRef.getParameters().put('currentRecordId', patientRequest.id);
        pageRef.getParameters().put('isPii', 'false');
        pageRef.getParameters().put('isTC', 'false');
        pageRef.getParameters().put('projectCountry', pc.Id);
        pageRef.getParameters().put('projectGroup', pc.Project__r.Project_Group__c);
        pageRef.getParameters().put('isStep7', 'false');
        pageRef.getParameters().put('isReviewer', 'false');
        Test.setCurrentPage(pageRef);
        Patient_Request_Eligibility__c eligibilityRecord = new Patient_Request_Eligibility__c();
        eligibilityRecord.Patient_Request__c = patientRequest.Id;
        eligibilityRecord.Project_Country_Eligibility__c = eligibilities.Id;
        insert eligibilityRecord;
        SummaryController controller = new SummaryController();
        controller.getEligibilitySupportingData1();
        controller.getTcData1();
        controller.getTcRest1();
        controller.getPhyData();
        controller.getpatientParameterData();
        controller.getPatientParameterOthers();
        controller.getpatientEligibilityData();
        controller.getpatientEligibilityExclusionData();
        controller.getpatientDosageData();
        controller.getPii();
        controller.getTC();
        ContentVersion newFile = new ContentVersion();
        newFile.PathOnClient = 'TestFile';
        newFile.Title = 'TestFile';
        newFile.VersionData = Blob.valueOf('sample content');
        insert newFile;
        ContentVersion insertedFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:newFile.Id];
        ContentDocumentLink linkedFile = new ContentDocumentLink(LinkedEntityId=patientRequest.Id, ContentDocumentId=insertedFile.ContentDocumentId);
        insert linkedFile;
        SummaryController.getDocumentId(patientRequest.Id);
        SummaryController.deleteDocument(insertedFile.ContentDocumentId);
    }    
    @isTest private static void loginTest(){
        System.Test.startTest();
        try{
            //SummaryController.getValueFromXMLString('test','test');
            //SummaryController.generatePdf('test');
            SummaryController.PatientRequestWrapper wrapperObj = new SummaryController.PatientRequestWrapper();
        } catch (Exception ex){ }
        System.Test.stopTest();
        
    }    
    public class UserCalloutMock implements HttpCalloutMock {
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('Success');
            return res;
        }
    }    
    public static testMethod void loginTest1() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new UserCalloutMock());
        SummaryController.login('test', 'password');
        Test.stopTest();
    }    
    public static testMethod void loginTest2() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new UserCalloutMock());
        SummaryController.getValueFromXMLString('test','test');
        Test.stopTest();
    }    
    public static testMethod void loginTest3() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new UserCalloutMock());
        SummaryController.getValueFromXMLString('test','test');
        Test.stopTest();
    }
    public static testMethod void loginTest4() {
        Patient_Request__c patientRequest = [select Id FROM Patient_Request__c limit 1];
        Project_Country__c pc = [select Id, Project__c, Project__r.Project_Group__c FROM Project_Country__c limit 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new UserCalloutMock());
        String jsonString = '{"patientReqId":"'+patientRequest.Id+'", "isStep7":"true", "isPii":"true", "isTC":"true", "projectGroup":"'+pc.Project__r.Project_Group__c+'", "projectCountry":"'+pc.Id+'"}';
        SummaryController.generatePdf(jsonString);
        Test.stopTest();
    }
}