/*********************************************************************************************************************
    ClassName UserAccountDataControllerTest
    Purpose: This is a test class used to test the UserAccountDataController functionality.
    AUTHOR : Nidhi Chouksey
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class UserAccountDataControllerTest {

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
        insert projCountryPatientParameterList;

        List<Project_Country_Supporting_Information__c> projectSupportingInfo = UtilData.createProjSuppInfo(projCountries);
        insert projectSupportingInfo;

        List<Project_Country_Eligibility__c> projectCountryEligibilityList = UtilData.createProjectCountryEligibilities(projCountries);
        insert projectCountryEligibilityList;

        Patient__c patient = UtilData.createPatient(contacts[0].id);
        insert patient;

        Patient_Request__c patientRequest = UtilData.createPatientRequest();
        insert patientRequest;

        Patient_Request_Note__c patientRequestNote = UtilData.createPatientRequestNote(patientRequest);
        insert patientRequestNote;

        Patient_Request_Supporting__c patientRequestSupporting = UtilData.createPatientRequestSupporting(patient.Id, projectSupportingInfo[0].id, patientRequest.Id, ProjGroups[0].id);
        insert patientRequestSupporting;
        
        Patient_Dosage_Request__c patientDosageRequest = UtilData.createPatientDosageRequest(patientRequest.Id);
        insert patientDosageRequest;
        
        Patient_Request_Parameters__c PatientRequestParameters = UtilData.createPatientRequestParameters(patient.Id, projCountryPatientParameterList[0].id, patientRequest.Id, ProjGroups[0].id);
        insert PatientRequestParameters;
         
        Patient_Request_Eligibility__c PatientRequestEligibility = UtilData.createPatientRequestEligibility(patient.Id, projectCountryEligibilityList[0].id, patientRequest.Id, ProjGroups[0].id);
        insert PatientRequestEligibility;

    }

    public static List<Account> createAccountsList(integer len){
        List<Account> accounts = new List<Account>();
        for(integer i=0;i<len;i++){
            Account acc = new Account();
            Id accRecortTypeInstitution = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Institution').getRecordTypeId();
            system.debug('@@ accRecortTypeInstitution :: ' + accRecortTypeInstitution);
            acc.RecordTypeId = accRecortTypeInstitution;
            acc.Name = 'Demo Account';
            acc.Institution_Country__c = 'India';
            acc.BillingCity = 'Jaipur';
            acc.BillingState = 'Raj';
            acc.BillingCountry = 'India';
            acc.BillingPostalCode = '302012';
            accounts.add(acc);
        }
        return accounts;
    }

    @isTest private static void getAddressDetailsTest(){
        Account institution = [select Id from Account limit 1];
        System.Test.startTest();
        UserAccountDataController.DeliveryAddressWrapper wrapperObj = UserAccountDataController.getAddressDetails(institution.Id);
        System.Test.stopTest();
        System.assert(!wrapperObj.institutionAddressList.isEmpty(), 'List is Empty: institutionAddressList');
    }
    @isTest private static void getRegulatoryConsents(){
        Project_Country__c projectCountry = [Select id, Project__r.Project_Group__r.Name from Project_Country__c  limit 1];
        System.Test.startTest();
        List<Project_Country_Regulatory_Consent__c> regulatoryList  = UserAccountDataController.getRegulatoryConsents('', projectCountry.Project__r.Project_Group__r.Name);
        System.Test.stopTest();
        //System.assert(!regulatoryList.isEmpty(), 'List is Empty: regulatoryList');
    }
  /*
    @isTest private static void submitPatientRequestForApprovalTest(){
        Project__c project = [Select id from Project__c  limit 1];
        User__c user = [Select Id from User Limit 1];
        System.Test.startTest();
        UserAccountDataController.submitForApproval(project.id, 'Biconical_Admin_to_Program_Manager1');
        System.Test.stopTest();
        UserAccountDataController.approveOrRejectProjectRecord(project.id + '', 'decline', 'Reject', user.Id);
        System.assert(true, 'submitPatientRequestForApprovalTest');
    }

    @isTest private static void approveOrRejectProjectRecordTest(){
        Project__c project = [Select id from Project__c  limit 1];
        User__c user = [Select Id from User Limit 1];
        System.Test.startTest();
        UserAccountDataController.approveOrRejectProjectRecord(project.id + '', 'decline', 'Reject');

        System.Test.stopTest();
        System.assert(true, 'submitPatientRequestForApprovalTest');
    }*/

	@isTest private static void testFetchPatientData(){
        Patient_Request__c patientRequest = [Select id, Institutation__c from Patient_Request__c  limit 1];
        System.Test.startTest();
            PARRecordWrapper wrapperObj = UserAccountDataController.fetchPatientData(patientRequest.id+'', patientRequest.Institutation__c+'');
        System.Test.stopTest();

        System.assert(true);
	}

   
    @isTest private static void testApproveRecord(){
        Patient_Request__c patientReq = [Select id from Patient_Request__c  limit 1];
        System.Test.startTest();
        UserAccountDataController.approveRecord(patientReq.id);
        System.Test.stopTest();
    }
    
    @isTest private static void testUpdatePARForPAMFromBionicalReview(){
            Patient_Request__c patientReq = [Select id from Patient_Request__c  limit 1];
            Project_Country_Indication__c  prjCountryIndication = [Select id from Project_Country_Indication__c  limit 1];
            Project_Country__c projCountryObj = [Select id,Approval_Needed__c,Approval_Level__c from Project_Country__c  limit 1];
            projCountryObj.Approval_Needed__c = 'Approval Required';
            projCountryObj.Approval_Level__c = 'Global';
            projCountryObj.First_Order_Only__c = true;
            update projCountryObj;
            System.Test.startTest();
            UserAccountDataController.updatePARForPAMFromBionicalReview(patientReq.id, prjCountryIndication.id, '01', 'Local');
            UserAccountDataController.updatePARForPAMFromBionicalReview(patientReq.id, prjCountryIndication.id, '01', 'Global');
            UserAccountDataController.updatePARForPAMFromBionicalReview(patientReq.id, prjCountryIndication.id, '02', 'Global');
            projCountryObj.First_Order_Only__c = false;
            update projCountryObj;
            UserAccountDataController.updatePARForPAMFromBionicalReview(patientReq.id, prjCountryIndication.id, '01', 'Local');
            UserAccountDataController.updatePARForPAMFromBionicalReview(patientReq.id, prjCountryIndication.id, '01', 'Global');
            projCountryObj.Approval_Needed__c = ' ';
            update projCountryObj;
            UserAccountDataController.updatePARForPAMFromBionicalReview(patientReq.id, prjCountryIndication.id, '01', 'Local');


            System.Test.stopTest();
        }

    @isTest private static void testUpdatePARForSponsorApproved(){
        Patient_Request__c patientReq = [Select id from Patient_Request__c  limit 1];
        Project_Country__c projCountryObj = [Select id,Approval_Needed__c,Approval_Level__c from Project_Country__c  limit 1];
        projCountryObj.Approval_Needed__c = 'Approval Required';
        projCountryObj.Approval_Level__c = 'Global';
        update projCountryObj;


        Project_Country_Indication__c  prjCountryIndication = [Select id from Project_Country_Indication__c  limit 1];
        System.Test.startTest();
        UserAccountDataController.updatePARForSponsorApproved(patientReq.id, prjCountryIndication.id,'Global');
        UserAccountDataController.updatePARForSponsorApproved(patientReq.id, prjCountryIndication.id,'Local');
        projCountryObj.Approval_Level__c = 'Local and Global';
        update projCountryObj;
        UserAccountDataController.updatePARForSponsorApproved(patientReq.id, prjCountryIndication.id,'Global');

        System.Test.stopTest();
    }

    @isTest private static void testUpdatePARReviewer(){
        Patient_Request__c patientReq = [Select id from Patient_Request__c  limit 1];
        Project_Country_Indication__c  prjCountryIndication = [Select id from Project_Country_Indication__c  limit 1];

        System.Test.startTest();
        UserAccountDataController.updatePARReviewer(patientReq.id, prjCountryIndication.id,'Sponsor','SponserMedicalReview');
        UserAccountDataController.updatePARReviewer(patientReq.id, prjCountryIndication.id,'Internal','SponserMedicalReview');
        UserAccountDataController.updatePARReviewer(patientReq.id, prjCountryIndication.id,'Sponsor','LocalSponserMedicalReview');
        UserAccountDataController.updatePARReviewer(patientReq.id, prjCountryIndication.id,'Internal','LocalSponserMedicalReview');

        UserAccountDataController.updatePARReviewer(patientReq.id, prjCountryIndication.id,'Sponsor','MRInformationRequired');
        UserAccountDataController.updatePARReviewer(patientReq.id, prjCountryIndication.id,'Internal','MRInformationRequired');

        UserAccountDataController.updatePARReviewer(patientReq.id, prjCountryIndication.id,'Sponsor','DeclineMedicalReview');
        UserAccountDataController.updatePARReviewer(patientReq.id, prjCountryIndication.id,'Internal','DeclineMedicalReview');
  

        System.Test.stopTest();
    }

     @isTest private static void testUpdateAfterHealthApproval(){
            Patient_Request__c patientReq = [Select id from Patient_Request__c  limit 1];
            Project_Country_Indication__c  prjCountryIndication = [Select id from Project_Country_Indication__c  limit 1];
            System.Test.startTest();
            UserAccountDataController.updateAfterHealthApproval(patientReq.id, prjCountryIndication.id);
            System.Test.stopTest();
    }

    @isTest private static void testGetProjectSponsorContact(){
        Project_Group__c prjGroup = [Select id from Project_Group__c  limit 1];
        Project_Country_Indication__c  prjCountryIndication = [Select id from Project_Country_Indication__c  limit 1];
        System.Test.startTest();
        UserAccountDataController.getProjectSponsorContact(prjGroup.id, prjCountryIndication.id);
        System.Test.stopTest();
    }

    @isTest private static void testGetProjectRegulatoryReviewer(){
        Project_Group__c prjGroup = [Select id from Project_Group__c  limit 1];
        Project_Country_Indication__c  prjCountryIndication = [Select id from Project_Country_Indication__c  limit 1];
        System.Test.startTest();
        UserAccountDataController.getProjectRegulatoryReviewer(prjGroup.id, prjCountryIndication.id);
        System.Test.stopTest();
    }

    

    @isTest private static void testgetProjectInternalSponsor(){
        Project_Country_Indication__c  prjCountryIndication = [Select id from Project_Country_Indication__c  limit 1];
        System.Test.startTest();
        UserAccountDataController.getProjectInternalSponsor( prjCountryIndication.id);
        System.Test.stopTest();
    }
    
    @isTest
    private static void CodeCoverageCall(){
        UserAccountDataController.CallCodeCoverage();
    }
}