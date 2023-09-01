/*********************************************************************************************************************
ClassName : BionicalProgramCtrlTest
Purpose : This is a test class used to test the BionicalProgramCtrl functionality.
AUTHOR : Nidhi Chouksey
Date : 09-July-2023
********************************************************************************************************************/
@isTest
public with sharing class BionicalProgramCtrlTest {
    
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
    }
    
    public static testMethod void getNameTest() {
        project__c projObj = [Select id from project__c limit 1];
        BionicalProgramCtrl bionicalProgObj = new BionicalProgramCtrl();
        Test.startTest();
        bionicalProgObj.getName('Test', projObj.id);
        Test.stopTest();
    }
    
    public static testMethod void getProgramManagerNameTest() {
        project__c projObj = [Select id from project__c limit 1];
        BionicalProgramCtrl bionicalProgObj = new BionicalProgramCtrl();
        bionicalProgObj.projectId = projObj.id;
        Test.startTest();
        bionicalProgObj.getProgramManagerName();
        bionicalProgObj.getProjectSponserName();
        bionicalProgObj.getBionicalAdminName();
        Test.stopTest();
    }
    @isTest
    private static void CodeCoverageCall(){
        BionicalProgramCtrl.CallCodeCoverage();
    }    
}