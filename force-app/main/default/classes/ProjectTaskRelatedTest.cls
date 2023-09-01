/*********************************************************************************************************************
    ClassName ProjectTaskRelatedTest
    Purpose: This is a test class used to test the ProjectTaskRelated functionality.
    AUTHOR : G Soundarya
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class ProjectTaskRelatedTest {
    public ProjectTaskRelatedTest() {    }

    @testSetup 
    static void setup() {

        Integer numberOfrecords = 1;
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
    }

    @isTest
    private static void projectTask(){

        Project_Country__c country = [select id,name from Project_Country__c limit 1];
        Project__c projdetails = [select id from Project__c];
        Project_Country_Indication__c countryindication = [select id from Project_Country_Indication__c];
        Project_Group__c grpid = [select id from Project_Group__c limit 1];

        test.startTest();
        ProjectTaskRelated.getProducts(country.Id);
        ProjectTaskRelated.GetProjectGroups(projdetails.id,projdetails.id);
        ProjectTaskRelated.GetIndication(grpid.id,country.name,projdetails.id);
        ProjectTaskRelated.getRegulatoryConsents(country.name,projdetails.id);
        test.stopTest();
    }
}