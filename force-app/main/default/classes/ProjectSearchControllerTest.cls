/*********************************************************************************************************************
    ClassName ProjectSearchControllerTest
    Purpose: This is a test class used to test the ProjectSearchController functionality.
    AUTHOR : G Soundarya
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class ProjectSearchControllerTest {
    public ProjectSearchControllerTest() {    }

    @testSetup 
    static void setup() {

        Integer numberOfrecords = 1;
        //List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        List<Account> createAccountsList = UtilData.createOrganizationAccount(numberOfrecords);
        insert createAccountsList;

        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
        projects[0].Project_Group__c = projGroups[0].id;
        projects[0].Organisation__c = createAccountsList[0].id;
        projects[0].Project_Status__c = 'Live';
        insert projects;
    }

    @isTest
    private static void testMethod1(){
        Account projectdetails = [select Id from Account limit 1];
        project__c progname = [select id,name from project__c limit 1];
        Project_Group__c grpname = [select name from Project_Group__c limit 1];

        test.startTest();

        ProjectSearchController.getprojectscountryData(projectdetails.Id);
        ProjectSearchController.searchProjects('Test',projectdetails.Id);
        //Negative testing
        ProjectSearchController.searchProjects('',projectdetails.Id);
        ProjectSearchController.searchProject(grpname.name,projectdetails.Id);
        ProjectSearchController.searchProject('Project Group',projectdetails.Id);
        //Negative testing
        ProjectSearchController.searchProject('',projectdetails.Id);
        ProjectSearchController.fetchPGDataName(progname.name);
        ProjectSearchController.fetchProjData(progname.Id);
        
        test.stoptest();
    }
}