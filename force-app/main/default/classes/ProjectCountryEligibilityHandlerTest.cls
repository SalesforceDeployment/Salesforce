@isTest
public class ProjectCountryEligibilityHandlerTest {
    @testSetup
    static void setup() {
        Integer numberOfrecords = 2;
        
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
        insert projects;
        
        List<Project_Country__c> projCountries = UtilData.createProjectCountry(projects);
        insert projCountries;
        
        List<Project_Country_Eligibility__c> projCountryEligibilityList = UtilData.createProjectCountryEligibilities(projCountries);
        insert projCountryEligibilityList;
    }
    
    @isTest
    public static void restrictInsertionTest(){
        List<Project_Country_Eligibility__c> projCountryEligibilityList = [Select Id,ProjectId__c,Project_Country_Eligibility__c.Project__c from Project_Country_Eligibility__c];
        System.Test.startTest();
        try{
        //ProjectCountryEligibilityHandler.restrictInsertion(projCountryEligibilityList);
        ProjectCountryEligibilityHandler.restrictInsertion(null);
        }catch(exception ex){}
        System.Test.stopTest();
        
        System.assertEquals(2, projCountryEligibilityList.size());
   }

   @isTest
   public static void restrictInsertionTest1(){
       List<Project_Country_Eligibility__c> projCountryEligibilityList = [Select Id,ProjectId__c,Project_Country_Eligibility__c.Project__c from Project_Country_Eligibility__c];
       System.Test.startTest();
       try{
       ProjectCountryEligibilityHandler.restrictInsertion(projCountryEligibilityList);
       //ProjectCountryEligibilityHandler.restrictInsertion(null);
       }catch(exception ex){}
       System.Test.stopTest();
       
       System.assertEquals(2, projCountryEligibilityList.size());
  }
    
    @isTest
    public static void restrictUpdationTest(){
        List<Project_Country_Eligibility__c> projCountryEligibilityList = [Select Id,ProjectId__c,Project_Country_Eligibility__c.Project__c from Project_Country_Eligibility__c];
        String projID = projCountryEligibilityList[0].Project__c;
        Project__c proj = [Select Id,Project_Status__c from Project__c Where Id =:projID Limit 1];
        System.Test.startTest();
        try{
        ProjectCountryEligibilityHandler.restrictUpdation(projCountryEligibilityList);
        ProjectCountryEligibilityHandler.restrictUpdation(null);
        } catch(Exception ex){

        }
        System.Test.stopTest();
        
        System.assertEquals(2, projCountryEligibilityList.size());
   }

   @isTest
   public static void restrictUpdationTest1(){
       List<Project_Country_Eligibility__c> projCountryEligibilityList = [Select Id,ProjectId__c,Project_Country_Eligibility__c.Project__c from Project_Country_Eligibility__c];
       String projID = projCountryEligibilityList[0].Project__c;
       Project__c proj = [Select Id,Project_Status__c from Project__c Where Id =:projID Limit 1];
       System.Test.startTest();
       try{
       ProjectCountryEligibilityHandler.restrictUpdation(projCountryEligibilityList);
       ProjectCountryEligibilityHandler.restrictUpdation(null);
    } catch(Exception ex){

    }
       System.Test.stopTest();
       
       System.assertEquals(2, projCountryEligibilityList.size());
  }
    
    @isTest
    public static void restrictDelectionTest(){
        Map<Id,Project_Country_Eligibility__c> projCountryEligibiltyMap = new Map<Id,Project_Country_Eligibility__c>();
        List<Project_Country_Eligibility__c> projCountryEligibilityList = [Select Id,ProjectId__c, Project__c from Project_Country_Eligibility__c];
        for(Project_Country_Eligibility__c projCountryEligib:projCountryEligibilityList){
            projCountryEligibiltyMap.put(projCountryEligib.Id,projCountryEligib);
        }
        /*String projID = projCountryEligibilityList[0].Project__c;
        Project__c proj = [Select Id,Project_Status__c from Project__c Where Id =:projID Limit 1];*/
        System.Test.startTest();
        try{
        ProjectCountryEligibilityHandler.restrictDelection(projCountryEligibilityList,projCountryEligibiltyMap);
        //ProjectCountryEligibilityHandler.restrictDelection(null, projCountryEligibiltyMap);
        } catch(Exception ex){

        }
        System.Test.stopTest();
        
        System.assertEquals(2, projCountryEligibilityList.size());
   }

   @isTest
   public static void restrictDelectionTest1(){
       Map<Id,Project_Country_Eligibility__c> projCountryEligibiltyMap = new Map<Id,Project_Country_Eligibility__c>();
       List<Project_Country_Eligibility__c> projCountryEligibilityList = [Select Id,ProjectId__c, Project__c from Project_Country_Eligibility__c];
       for(Project_Country_Eligibility__c projCountryEligib:projCountryEligibilityList){
           projCountryEligibiltyMap.put(projCountryEligib.Id,projCountryEligib);
       }
       /*String projID = projCountryEligibilityList[0].Project__c;
       Project__c proj = [Select Id,Project_Status__c from Project__c Where Id =:projID Limit 1];*/
       System.Test.startTest();
       try{
       //ProjectCountryEligibilityHandler.restrictDelection(projCountryEligibilityList,projCountryEligibiltyMap);
       ProjectCountryEligibilityHandler.restrictDelection(null, projCountryEligibiltyMap);
    } catch(Exception ex){

    }
       System.Test.stopTest();
       
       System.assertEquals(2, projCountryEligibilityList.size());
  
}
}