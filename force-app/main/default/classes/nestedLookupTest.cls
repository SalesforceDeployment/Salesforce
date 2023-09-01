/*********************************************************************************************************************
    ClassName nestedLookupTest
    Purpose: This is a test class used to test the nestedLookup functionality.
    AUTHOR : G Soundarya
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class nestedLookupTest {
    public nestedLookupTest() {    }

    @TestSetup
    static void makeData(){

        Integer numberOfrecords = 1;
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
       // projects[0].Project_Status__c='Live';
        insert projects;
        

        List<Indication__c> indications = UtilData.createIndications(projects);
        insert indications; 
        
        List<Project_Country__c> projCountries = UtilData.createProjectCountry(projects);
        projCountries[0].Country__c='India';
        insert projCountries;

        List<Project_Country_Indication__c > projectIndicationCountries = UtilData.createProjectCountryIndications(indications,projCountries);
        insert projectIndicationCountries;

        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        createAccountsList[0].Institution_Country__c='India';
        insert createAccountsList;

         project__c projecttest = [SELECT Id,Name  FROM project__c LIMIT 1];
         projecttest.Project_Status__c = 'Draft in Review';
         update projecttest;

         project__c projecttest1 = [SELECT Id,Name  FROM project__c LIMIT 1];
         projecttest.Project_Status__c = 'Draft Project Approved';
         update projecttest;

         project__c projecttest2 = [SELECT Id,Name  FROM project__c LIMIT 1];
         projecttest.Project_Status__c = 'Live';
         update projecttest;
    }

    @istest
    private static void Testnest(){

        List<id> dose = new List<id>();

        test.startTest();
        list<nestedLookup.Wrapper> wrapperList = nestedLookup.getNestedindi(dose,'0052z000004R4LRAA0');
        system.debug(wrapperList);
        test.stopTest();
    }
    
    @isTest
    public static void wrapperTest(){
        Test.startTest();
        nestedLookup.Wrapper wrapperObj = new nestedLookup.Wrapper('Test','Test',new List<Dosing_Detail__c>(),new List<Project_Country_Eligibility__c>());
        Test.stopTest();
        
    }
    
    @isTest
    public static void getNestedTest(){
        Account acc = [select id,name from Account limit 1];
        Care_Products__c products = [select id,name from Care_Products__c limit 1];
        List<Id> prodIds = new List<Id>();
        prodIds.add(products.id);
        Test.startTest();
        nestedLookup.getNestedindi(prodIds,acc.id);
        Test.stopTest();
    }
}