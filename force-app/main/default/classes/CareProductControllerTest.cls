@isTest
public with sharing class CareProductControllerTest {
    public CareProductControllerTest() {

    }
    @testSetup 
    static void setup() {
        Integer numberOfrecords = 1;
        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        insert createAccountsList;
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        products[0].Is_Active__c = true;
        insert products;
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        ProjGroups[0].Status__c = 'Live';
        insert ProjGroups;
        List<project__c> projects = UtilData.createProject(ProjGroups);
        insert projects;
        List<Indication__c> indications = UtilData.createIndications(projects);
        insert indications; 
        List<Project_Country__c> projCountries = UtilData.createProjectCountry(projects);
        projCountries[0].Country__c = 'India';
        insert projCountries;
        List<Institution_Treatment__c> treatment = UtilData.createInstitutionTreatmentList(createAccountsList, ProjGroups);
        insert treatment;
        

    }
    @isTest private static void CareProductTest(){
        Account acc = [select Id from Account limit 1];
        Care_Products__c prd = [select Id from Care_Products__c limit 1];
        Project_Group__c prdGrp = [select Id from Project_Group__c limit 1];
        Indication__c pcInd = [select Id from Indication__c limit 1];
        Project_Country__c cntry = [select Id from Project_Country__c limit 1];
        Institution_Treatment__c insTreat = [select Id from Institution_Treatment__c limit 1];
        System.Test.startTest();
        CareProductController.getProducts(acc.Id);
        CareProductController.GetProjectGroups(acc.Id,prd.Id);
        CareProductController.GetIndication(prdGrp.Id, cntry.Id);
        CareProductController.GetIndicationForEdit(pcInd.Id);
        CareProductController.checkInstitutionEligibility(acc.Id, prd.Id, prdGrp.Id, pcInd.Id);
        System.Test.stopTest();
    }
}