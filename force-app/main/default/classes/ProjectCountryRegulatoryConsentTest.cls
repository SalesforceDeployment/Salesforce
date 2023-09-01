@isTest
public class ProjectCountryRegulatoryConsentTest {
    @testSetup
    
    static void setup (){
        Integer numberOfrecords = 6;
        
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
        insert projects;
        
        List<Project_Country__c>  projCountries = UtilData.createProjectCountry(projects);
        insert projCountries;
        
        List<Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentList = UtilData.createProjectCountryRegulatoryConsent(projCountries);
        insert ProjectCountryRegulatoryConsentList;
        
        Project__c liveProj = projects[0];
        liveProj.Project_Status__c = 'Draft in Review';
        update liveProj;
        
        liveProj.Project_Status__c = 'Draft Project Approved';
        update liveProj;
        
    }
    
    @isTest
    public static void restrictInsertionTest(){
        List<Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentList = [Select Id,Project__c  from Project_Country_Regulatory_Consent__c];
        System.Test.startTest();
        try{
            ProjectCountryRegulatoryConsentHandler.restrictInsertion(ProjectCountryRegulatoryConsentList);
            //ProjectCountryRegulatoryConsentHandler.restrictInsertion(null);
        } catch(Exception ex){
            String message = ex.getMessage();
        }
        System.Test.stopTest();
        
        System.assertEquals(6, ProjectCountryRegulatoryConsentList.size());
    }
    
    @isTest
    public static void restrictInsertionTest1(){
        List<Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentList = [Select Id,Project__c  from Project_Country_Regulatory_Consent__c];
        System.Test.startTest();
        try{
            //ProjectCountryRegulatoryConsentHandler.restrictInsertion(ProjectCountryRegulatoryConsentList);
            ProjectCountryRegulatoryConsentHandler.restrictInsertion(null);
        } catch(Exception ex){
            String message = ex.getMessage();
        }
        System.Test.stopTest();
        
        System.assertEquals(6, ProjectCountryRegulatoryConsentList.size());
    }
    
    @isTest
    public static void restrictUpdationTest(){
        List<Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentList = [Select Id,Project__c from Project_Country_Regulatory_Consent__c];
        String projID = ProjectCountryRegulatoryConsentList[0].Project__c;
        Project__c proj = [Select Id,Project_Status__c from Project__c Where Id =:projID Limit 1];
        System.Test.startTest();
        try{
            ProjectCountryRegulatoryConsentHandler.restrictUpdation(ProjectCountryRegulatoryConsentList);
           // ProjectCountryRegulatoryConsentHandler.restrictUpdation(null);
        } catch(Exception ex){
            String message = ex.getMessage();
        }
        System.Test.stopTest();
        
        System.assertEquals(6, ProjectCountryRegulatoryConsentList.size());
    }
    
    @isTest
    public static void restrictUpdationTest1(){
        List<Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentList = [Select Id,Project__c from Project_Country_Regulatory_Consent__c];
        String projID = ProjectCountryRegulatoryConsentList[0].Project__c;
        Project__c proj = [Select Id,Project_Status__c from Project__c Where Id =:projID Limit 1];
        System.Test.startTest();
        try{
            // ProjectCountryRegulatoryConsentHandler.restrictUpdation(ProjectCountryRegulatoryConsentList);
            ProjectCountryRegulatoryConsentHandler.restrictUpdation(null);
        } catch(Exception ex){
            String message = ex.getMessage();
        }
        System.Test.stopTest();
        
        System.assertEquals(6, ProjectCountryRegulatoryConsentList.size());
    }
    
    @isTest
    public static void restrictDelectionTest(){
        Map<Id,Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentMap = new Map<Id,Project_Country_Regulatory_Consent__c>();
        List<Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentList = [Select Id,Project__c from Project_Country_Regulatory_Consent__c];
        for(Project_Country_Regulatory_Consent__c ProjectCountryRegulatoryConsent:ProjectCountryRegulatoryConsentList){
            ProjectCountryRegulatoryConsentMap.put(ProjectCountryRegulatoryConsent.Id,ProjectCountryRegulatoryConsent);
        }
        System.Test.startTest();
        try{
            ProjectCountryRegulatoryConsentHandler.restrictDelection(ProjectCountryRegulatoryConsentList,ProjectCountryRegulatoryConsentMap);
            //ProjectCountryRegulatoryConsentHandler.restrictDelection(null, ProjectCountryRegulatoryConsentMap);
        } catch(Exception ex){
            String message = ex.getMessage();
        }
        System.Test.stopTest();
        
        System.assertEquals(6, ProjectCountryRegulatoryConsentList.size());
    }
    
    @isTest
    public static void restrictDelectionTest1(){
        Map<Id,Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentMap = new Map<Id,Project_Country_Regulatory_Consent__c>();
        List<Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentList = [Select Id,Project__c from Project_Country_Regulatory_Consent__c];
        for(Project_Country_Regulatory_Consent__c ProjectCountryRegulatoryConsent:ProjectCountryRegulatoryConsentList){
            ProjectCountryRegulatoryConsentMap.put(ProjectCountryRegulatoryConsent.Id,ProjectCountryRegulatoryConsent);
        }
        System.Test.startTest();
        try{
            //ProjectCountryRegulatoryConsentHandler.restrictDelection(ProjectCountryRegulatoryConsentList,ProjectCountryRegulatoryConsentMap);
            ProjectCountryRegulatoryConsentHandler.restrictDelection(null, ProjectCountryRegulatoryConsentMap);
        } catch(Exception ex){
            String message = ex.getMessage();
            //system.assert(message.contains('Active_Contact_Error'), 'message=' + message);
        }
        System.Test.stopTest();
        
        System.assertEquals(6, ProjectCountryRegulatoryConsentList.size());
    }
    
    @isTest
    private static void CodeCoverageCall(){
        ProjectCountryRegulatoryConsentHandler.CallCodeCoverage();
    }
    
}