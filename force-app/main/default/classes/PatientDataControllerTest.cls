/*********************************************************************************************************************
    ClassName PatientDataControllerTest
    Purpose: This is a test class used to test the PatientDataController functionality.
    AUTHOR : Nidhi Chouksey
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class PatientDataControllerTest {
    public PatientDataControllerTest() {

    }

    @testSetup 
    static void setup() {
        Integer numberOfrecords = 1;
        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        insert createAccountsList;

        List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        insert contacts;

        /*List<Institution_Additional_Address__c> institutionAdditionalAddressList =  UtilData.createInstitutionAddress(createAccountsList);
        insert institutionAdditionalAddressList; */

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
        system.debug('@@ patient ' + patient.id);
        Patient_Request__c patientRequest = UtilData.createPatientRequest();
        insert patientRequest;
        system.debug('@@ patientRequest ' + patientRequest.id);

        Patient_Request_Note__c patientRequestNote = UtilData.createPatientRequestNote(patientRequest);
        insert patientRequestNote;

        Patient_Request_Supporting__c patientRequestSupporting = UtilData.createPatientRequestSupporting(patient.Id, projectSupportingInfo[0].id, patientRequest.Id, ProjGroups[0].id);
        insert patientRequestSupporting;

        Patient_Dosage_Request__c patientDosageRequest = UtilData.createPatientDosageRequest(patientRequest.Id);
        insert patientDosageRequest;

        

    }

    
    @isTest private static void getProjectCountryRegulatoryDataTest(){
        Project_Country_Indication__c ProjCountryRegConsentObj = [select Id from Project_Country_Indication__c limit 1];
        System.Test.startTest();
        PatientDataController.getProjectCountryRegulatoryData(ProjCountryRegConsentObj.id);
        System.Test.stopTest();
    }

    @isTest private static void getAdditionalAndAdverseInfoTest(){
        Project_Country_Indication__c ProjCountryIdnObj = [select Id from Project_Country_Indication__c limit 1];
        System.Test.startTest();
        PatientDataController.getAdditionalAndAdverseInfo(ProjCountryIdnObj.id);
        System.Test.stopTest();
    }

    @isTest private static void getDosingDetailsforPatientTest(){
        Project_Country_Indication__c projCountryIdnObj = [select Id from Project_Country_Indication__c limit 1];
        Patient_Request__c patientAccessReq = [select Id from Patient_Request__c limit 1];

        System.Test.startTest();
        PatientDataController.getDosingDetailsforPatient(projCountryIdnObj.id, patientAccessReq.id);
        PatientDataController.getDosingDetailsforPatient(projCountryIdnObj.id, projCountryIdnObj.id);

        System.Test.stopTest();
    }

    /**/
    @isTest public static void getProjectCodeTest(){
        Project_Country_Indication__c projCountryIdnObj = [select Id from Project_Country_Indication__c limit 1];
        System.Test.startTest();
        PatientDataController.getProjectCode(projCountryIdnObj.Id);
        System.Test.stopTest();
    }

}