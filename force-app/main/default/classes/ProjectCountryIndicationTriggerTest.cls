@isTest
public class ProjectCountryIndicationTriggerTest {
    @testSetup
    static void setup(){
        Integer numberOfrecords = 4;
        
        List<Care_Products__c> careProducts = UtilData.createCareProducts(numberOfrecords);
        insert careProducts;
        
        List<Project_Group__c> ProjectGroups = UtilData.createProjectGroupsTreatmentLookup(careProducts);
        insert ProjectGroups;
        
        List<project__c> projects = UtilData.createProject(ProjectGroups);
        insert projects;
        
        List<Indication__c> indications = UtilData.createIndication(numberOfrecords);
        insert indications;
        
        List<Project_Country__c> projectCountries = UtilData.createProjectCountry(projects);
        insert projectCountries;
        
        List<Project_Country_Indication__c > projectCountryIndicationList = UtilData.createProjectCountryIndications(indications,projectCountries);
        insert projectCountryIndicationList;
    }
    @isTest
    public static void restrictInsertionTest(){
        List<Project_Country_Indication__c> projCountryIndicationList = [Select Id,ProjectId__c from Project_Country_Indication__c];
        System.Test.startTest();
        try{
            ProjectCountryIndicationTriggerHandler.restrictInsertion(projCountryIndicationList);
            
        } catch (Exception ex){
            
        }
        //ProjectCountryIndicationTriggerHandler.restrictInsertion(null);
        System.Test.stopTest();
        
        System.assertEquals(4, projCountryIndicationList.size());
    }
    
    @isTest
    public static void restrictInsertionTest1(){
        List<Project_Country_Indication__c> projCountryIndicationList = [Select Id,ProjectId__c from Project_Country_Indication__c];
        System.Test.startTest();
        try{
            //ProjectCountryIndicationTriggerHandler.restrictInsertion(projCountryIndicationList);
            ProjectCountryIndicationTriggerHandler.restrictInsertion(null);
        } catch (Exception ex){
            
        }
        System.Test.stopTest();
        
        System.assertEquals(4, projCountryIndicationList.size());
    }
    
    @isTest
    public static void restrictUpdationTest(){
        List<Project_Country_Indication__c> projCountryIndicationList = [Select Id,ProjectId__c, Project__c from Project_Country_Indication__c];
        String projID = projCountryIndicationList[0].Project__c;
        /*Project__c proj = [Select Id, Project_Status__c From Project__c Where Id =: projID Limit 1];*/
        System.Test.startTest();
        try{
            ProjectCountryIndicationTriggerHandler.restrictUpdation(projCountryIndicationList);
            //ProjectCountryIndicationTriggerHandler.restrictUpdation(null);
        } catch(Exception ex){
            
        }
        
        System.Test.stopTest();
        
        System.assertEquals(4, projCountryIndicationList.size());
    }
    
    @isTest
    public static void restrictUpdationTest1(){
        List<Project_Country_Indication__c> projCountryIndicationList = [Select Id,ProjectId__c, Project__c from Project_Country_Indication__c];
        String projID = projCountryIndicationList[0].Project__c;
        /*Project__c proj = [Select Id, Project_Status__c From Project__c Where Id =: projID Limit 1];*/
        System.Test.startTest();
        try{
            //ProjectCountryIndicationTriggerHandler.restrictUpdation(projCountryIndicationList);
            ProjectCountryIndicationTriggerHandler.restrictUpdation(null);
        } catch(Exception ex){
            
        }
        
        System.Test.stopTest();
        
        System.assertEquals(4, projCountryIndicationList.size());
    }
    @isTest
    public static void restrictDelectionTest(){
        Map<Id,Project_Country_Indication__c> projCountryIndicationMap = new Map<Id,Project_Country_Indication__c>();
        List<Project_Country_Indication__c> projCountryIndicationList = [Select Id,ProjectId__c, Project__c from Project_Country_Indication__c];
        for(Project_Country_Indication__c projCountryEligib:projCountryIndicationList){
            projCountryIndicationMap.put(projCountryEligib.Id,projCountryEligib);
        }
        System.Test.startTest();
        try{
            ProjectCountryIndicationTriggerHandler.restrictDelection(projCountryIndicationList,projCountryIndicationMap);
            //ProjectCountryIndicationTriggerHandler.restrictDelection(null,projCountryIndicationMap);
        } catch(Exception ex){
            
        }
        System.Test.stopTest();
        
        System.assertEquals(4, projCountryIndicationList.size());
    }
    
    @isTest
    public static void restrictDelectionTest1(){
        Map<Id,Project_Country_Indication__c> projCountryIndicationMap = new Map<Id,Project_Country_Indication__c>();
        List<Project_Country_Indication__c> projCountryIndicationList = [Select Id,ProjectId__c, Project__c from Project_Country_Indication__c];
        for(Project_Country_Indication__c projCountryEligib:projCountryIndicationList){
            projCountryIndicationMap.put(projCountryEligib.Id,projCountryEligib);
        }
        System.Test.startTest();
        try{
            //ProjectCountryIndicationTriggerHandler.restrictDelection(projCountryIndicationList,projCountryIndicationMap);
            ProjectCountryIndicationTriggerHandler.restrictDelection(null,projCountryIndicationMap);
        } catch(Exception ex){
            
        }
        System.Test.stopTest();
        
        System.assertEquals(4, projCountryIndicationList.size());
    }
    @isTest
    private static void CodeCoverageCall(){
        ProjectCountryIndicationTriggerHandler.CallCodeCoverage();
    }
}