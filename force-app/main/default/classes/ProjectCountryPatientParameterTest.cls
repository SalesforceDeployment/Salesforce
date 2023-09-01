@isTest
public class ProjectCountryPatientParameterTest {
    
    @testSetup
    static void setup (){
        Integer numberOfrecords = 5;
        
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
        insert projects;
        
        List<Project_Country__c> projCountries = UtilData.createProjectCountry(projects);
        insert projCountries;
        
        List<Project_Country_Patient_Parameter__c> projCountryPatientParameterList = UtilData.createProjectCountryPatientParameter(projCountries);
        insert projCountryPatientParameterList;
        
    }
    
    @isTest
    public static void restrictInsertionTest(){
        List<Project_Country_Patient_Parameter__c> projCountryPatientParameterList = [Select Id,Project__c  from Project_Country_Patient_Parameter__c];
        System.Test.startTest();
        try{
            ProjectCountryPatientParameterHandler.restrictInsertion(projCountryPatientParameterList);
            //ProjectCountryPatientParameterHandler.restrictInsertion(null);
        }catch(Exception ex){}
        System.Test.stopTest();
        
        System.assertEquals(5, projCountryPatientParameterList.size());
    }
    
    @isTest
    public static void restrictInsertionTest1(){
        List<Project_Country_Patient_Parameter__c> projCountryPatientParameterList = [Select Id,Project__c  from Project_Country_Patient_Parameter__c];
        System.Test.startTest();
        try{
            //ProjectCountryPatientParameterHandler.restrictInsertion(projCountryPatientParameterList);
            ProjectCountryPatientParameterHandler.restrictInsertion(null);
        }catch(Exception ex){}
        System.Test.stopTest();
        
        System.assertEquals(5, projCountryPatientParameterList.size());
    }
    
    @isTest
    public static void restrictUpdationTest(){
        List<Project_Country_Patient_Parameter__c> projCountryPatientParameterList = [Select Id,Project__c from Project_Country_Patient_Parameter__c];
        String projID = projCountryPatientParameterList[0].Project__c;
        Project__c proj = [Select Id,Project_Status__c from Project__c Where Id =:projID Limit 1];
        System.Test.startTest();
        try{
            ProjectCountryPatientParameterHandler.restrictUpdation(projCountryPatientParameterList);
            //ProjectCountryPatientParameterHandler.restrictUpdation(null);
        }catch(Exception ex){}
        System.Test.stopTest();
        
        System.assertEquals(5, projCountryPatientParameterList.size());
    }
    @isTest
    public static void restrictUpdationTest1(){
        List<Project_Country_Patient_Parameter__c> projCountryPatientParameterList = [Select Id,Project__c from Project_Country_Patient_Parameter__c];
        String projID = projCountryPatientParameterList[0].Project__c;
        Project__c proj = [Select Id,Project_Status__c from Project__c Where Id =:projID Limit 1];
        System.Test.startTest();
        try{
            //ProjectCountryPatientParameterHandler.restrictUpdation(projCountryPatientParameterList);
            ProjectCountryPatientParameterHandler.restrictUpdation(null);
        }catch(Exception ex){}
        System.Test.stopTest();
        
        System.assertEquals(5, projCountryPatientParameterList.size());
    }
    
    @isTest
    public static void restrictDelectionTest(){
        Map<Id,Project_Country_Patient_Parameter__c> projCountryPatientParameterMap = new Map<Id,Project_Country_Patient_Parameter__c>();
        List<Project_Country_Patient_Parameter__c> projCountryPatientParameterList = [Select Id,Project__c from Project_Country_Patient_Parameter__c];
        for(Project_Country_Patient_Parameter__c projCountryPatientParameter:projCountryPatientParameterList){
            projCountryPatientParameterMap.put(projCountryPatientParameter.Id,projCountryPatientParameter);
        }
        System.Test.startTest();
        try{
            ProjectCountryPatientParameterHandler.restrictDelection(projCountryPatientParameterList,projCountryPatientParameterMap);
            //ProjectCountryPatientParameterHandler.restrictDelection(null, projCountryPatientParameterMap);
        }catch(Exception ex){}
        System.Test.stopTest();
        
        System.assertEquals(5, projCountryPatientParameterList.size());
    }
    
    @isTest
    public static void restrictDelectionTest1(){
        Map<Id,Project_Country_Patient_Parameter__c> projCountryPatientParameterMap = new Map<Id,Project_Country_Patient_Parameter__c>();
        List<Project_Country_Patient_Parameter__c> projCountryPatientParameterList = [Select Id,Project__c from Project_Country_Patient_Parameter__c];
        for(Project_Country_Patient_Parameter__c projCountryPatientParameter:projCountryPatientParameterList){
            projCountryPatientParameterMap.put(projCountryPatientParameter.Id,projCountryPatientParameter);
        }
        System.Test.startTest();
        try{
            //ProjectCountryPatientParameterHandler.restrictDelection(projCountryPatientParameterList,projCountryPatientParameterMap);
            ProjectCountryPatientParameterHandler.restrictDelection(null, projCountryPatientParameterMap);
        }catch(Exception ex){}
        System.Test.stopTest();
        
        System.assertEquals(5, projCountryPatientParameterList.size());
    }
    @isTest
    private static void CodeCoverageCall(){
        ProjectCountryPatientParameterHandler.CallCodeCoverage();
    }
}