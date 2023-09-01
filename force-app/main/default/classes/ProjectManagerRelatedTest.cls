/*********************************************************************************************************************
    ClassName projectDataControllerTest
    Purpose: This is a test class used to test the projectDataController functionality.
    AUTHOR : Nidhi Chouksey
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class ProjectManagerRelatedTest {
    public ProjectManagerRelatedTest() { }

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

    @isTest private static void getAddressDetailsTest(){
        Project_Country__c projCountries = [select Id from Project_Country__c limit 1];
        System.Test.startTest();
            ProjectManagerRelated.getProducts(projCountries.id);
        System.Test.stopTest();
    }

    @isTest private static void getProjectGroupsTest(){
        project__c projectObj = [select Id from project__c limit 1];
        System.Test.startTest();
            ProjectManagerRelated.GetProjectGroups(projectObj.id, projectObj.id);
        System.Test.stopTest();
    }

    @isTest private static void getIndicationTest(){
        project__c projectObj = [select Id from project__c limit 1];
        Project_Group__c projectGroupObj = [select Id from Project_Group__c limit 1];
        System.Test.startTest();
            ProjectManagerRelated.GetIndication(projectGroupObj.id, 'India',projectObj.id);
        System.Test.stopTest();
    }

    @isTest private static void getRegulatoryConsentsTest(){
        Project_Group__c projectGroupObj = [select Id from Project_Group__c limit 1];
        System.Test.startTest();
            ProjectManagerRelated.getRegulatoryConsents('India', projectGroupObj.Id);
        System.Test.stopTest();
    }

}