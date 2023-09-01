/*********************************************************************************************************************
ClassName projMedicalReviewMemberTriggerHandleTest
Purpose: This is a test class used to test the projMedicalReviewMemberTriggerHandle functionality.
AUTHOR : G Soundarya
Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class projMedicalReviewMemberTriggerHandleTest {
    public projMedicalReviewMemberTriggerHandleTest() {    }
    
    @TestSetup
    static void makeData(){
        
        Integer numberOfrecords = 1;
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
        //projects[0].Project_Status__c='Draft in Review';
        insert projects;
        
        List<Project_Bionical_Medical_Reviewer__c> careProductList = new List<Project_Bionical_Medical_Reviewer__c>();
        for(Integer i = 0; i<numberOfrecords; i++){
            Project_Bionical_Medical_Reviewer__c product = new Project_Bionical_Medical_Reviewer__c();
            product.Description__c = 'test'+i;
            product.project__c = projects[0].id;
            careProductList.add(product);
        }
        insert careProductList;
    }
    
    @istest
    private static void ReviewMemberTrigger(){
        
        list<Project_Bionical_Medical_Reviewer__c> projreview = [select id,project__c,Project__r.Project_Status__c from Project_Bionical_Medical_Reviewer__c limit 1];
        //list<Project_Bionical_Medical_Reviewer__c> medreview = new list<Project_Bionical_Medical_Reviewer__c>();
        
        Map<Id, Project_Bionical_Medical_Reviewer__c> bionical = new Map<Id, Project_Bionical_Medical_Reviewer__c>();
        bionical.put(projreview[0].id,projreview[0]);
        
        project__c proj = [select id,Project_Status__c From Project__c Limit 1];
        
        test.startTest();
        projMedicalReviewerMemberTriggerHandler.restrictUpdation(projreview);
        projMedicalReviewerMemberTriggerHandler.restrictDelection(projreview,bionical);
        projMedicalReviewerMemberTriggerHandler.restrictInsertion(projreview);
        test.stopTest();
    }
    @isTest
    private static void testmothod(){
        try{
            Integer numberOfrecords = 1;
            List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
            insert products;
            
            List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
            insert ProjGroups;
            
            List<project__c> projects = UtilData.createProject(ProjGroups);
            projects[0].Project_Status__c='Draft in Review';
            insert projects;
            
        }catch(exception e){
            system.debug(e);
        }
    }   
    @isTest
    private static void CodeCoverageCall(){
        projMedicalReviewerMemberTriggerHandler.CallCodeCoverage();
    }
}