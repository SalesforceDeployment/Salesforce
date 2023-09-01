/*********************************************************************************************************************
    ClassName TreatmentDetailsTest
    Purpose: This is a test class used to test the TreatmentDetails functionality.
    AUTHOR : Nidhi Chouksey
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class TreatmentDetailsTest {
    public TreatmentDetailsTest() {}

    @testSetup 
    static void setup() {
        Integer numberOfrecords = 1;
        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        insert createAccountsList;

        List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        insert contacts;

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

        Patient__c patient = UtilData.createPatient(contacts[0].id);
        insert patient;
        
        Patient_Request__c patientRequest = UtilData.createPatientRequest();
        insert patientRequest;

    }

    @isTest private static void getAllindicationTest(){
        System.Test.startTest();
        TreatmentDetails.getAllindication();
        System.Test.stopTest();
    }
}