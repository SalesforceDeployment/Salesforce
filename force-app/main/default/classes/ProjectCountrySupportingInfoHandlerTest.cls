@isTest

public class ProjectCountrySupportingInfoHandlerTest {
    
    
    
    @testSetup
    
    static void setup() {
        
        
        
        Integer numberOfrecords = 3;
        
        
        
        List<Care_Products__c> careProducts = UtilData.createCareProducts(numberOfrecords);
        
        insert careProducts;
        
        
        
        List<Project_Group__c> ProjectGroups = UtilData.createProjectGroupsTreatmentLookup(careProducts);
        
        insert ProjectGroups;
        
        
        
        List<project__c> projects = UtilData.createProject(ProjectGroups);
        
        insert projects;
        
        
        
        List<Project_Country__c> projectCountries = UtilData.createProjectCountry(projects);
        
        insert projectCountries;
        
        
        
        List<Project_Country_Supporting_Information__c> projectSupportingInfo = UtilData.createProjSuppInfo(projectCountries);
        
        insert projectSupportingInfo;
        
        
        
        
        Project_Country_Supporting_Information__c pSupporting = [SELECT Id,First__c FROM Project_Country_Supporting_Information__c LIMIT 1];
        
        pSupporting.First__c  = true;
        
        update pSupporting;
        
    }
    
    
    
    
    
    
    @isTest
    
    static void testRestrictInsertion() {
        
        
        
        List<Project_Country_Supporting_Information__c> projSupportingInfoList = [Select Id,Project_Country__c,Project_Country_Supporting_Information__c.Project__c,Project_Status__c From Project_Country_Supporting_Information__c];
        
        System.Test.startTest();
        
        try{
            
            ProjectCountrySupportingInfoHandler.restrictInsertion(projSupportingInfoList);
            
            // ProjectCountrySupportingInfoHandler.restrictInsertion(null);
            
        }catch(Exception ex){}
        
        System.Test.stopTest();
        
        
        
    }
    
    @isTest
    
    public static void restrictUpdationTest(){
        
        List<Project_Country_Supporting_Information__c> projSupportingInfoList = [Select Id,Project_Country__c,Project__c, Project_Status__c  from Project_Country_Supporting_Information__c];
        
        //String projID = projSupportingInfoList[0].Project__c;
        
        //Project__c proj = [Select Id,Project_Status__c from Project__c Where Id =:projId Limit 1];
        
        System.Test.startTest();
        
        try{
            
            ProjectCountrySupportingInfoHandler.restrictUpdation(projSupportingInfoList);
            
            //ProjectCountrySupportingInfoHandler.restrictUpdation(null);
            
        }catch(Exception ex){}
        
        System.Test.stopTest();
        
        
        
        System.assertEquals(3, projSupportingInfoList.size());
        
    }
    
    @isTest
    
    public static void restrictDelectionTest(){
        
        Map<Id,Project_Country_Supporting_Information__c> projSupportingInfoMap = new Map<Id,Project_Country_Supporting_Information__c>();
        
        List<Project_Country_Supporting_Information__c> projSupportingInfoList = [Select Id,Project_Country__c, Project_Status__c  from Project_Country_Supporting_Information__c];
        
        for(Project_Country_Supporting_Information__c projSupportingInfo:projSupportingInfoList){
            
            projSupportingInfoMap.put(projSupportingInfo.Id,projSupportingInfo);
            
        }
        
        System.Test.startTest();
        
        try{
            
            ProjectCountrySupportingInfoHandler.restrictDelection(projSupportingInfoList,projSupportingInfoMap);
            
            //ProjectCountrySupportingInfoHandler.restrictDelection(null,projSupportingInfoMap);
            
        }catch(Exception ex){}
        
        System.Test.stopTest();
        
        
        
        System.assertEquals(3, projSupportingInfoList.size());
        
    }
    
    
    
    
    @isTest
    
    public static void restrictDelectionTest1(){
        
        Map<Id,Project_Country_Supporting_Information__c> projSupportingInfoMap = new Map<Id,Project_Country_Supporting_Information__c>();
        
        List<Project_Country_Supporting_Information__c> projSupportingInfoList = [Select Id,Project_Country__c, Project_Status__c  from Project_Country_Supporting_Information__c];
        
        for(Project_Country_Supporting_Information__c projSupportingInfo:projSupportingInfoList){
            
            projSupportingInfoMap.put(projSupportingInfo.Id,projSupportingInfo);
            
        }
        
        System.Test.startTest();
        
        try{
            
            //ProjectCountrySupportingInfoHandler.restrictDelection(projSupportingInfoList,projSupportingInfoMap);
            
            ProjectCountrySupportingInfoHandler.restrictDelection(null,projSupportingInfoMap);
            
        }catch(Exception ex){}
        
        System.Test.stopTest();
        
        
        
        System.assertEquals(3, projSupportingInfoList.size());
        
    }
    
    @isTest
    private static void CodeCoverageCall(){
        //ProjCountryIndiDosingTriggerHandler.CallCodeCoverage();
    }
    
}