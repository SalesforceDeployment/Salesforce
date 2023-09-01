@isTest
public class ProjectIndicationTriggerTest {
        
    @testSetup
    static void setup() {
        
        Integer numberOfrecords = 2;
        
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
        insert projects;
        
        List<Indication__c> indications = UtilData.createIndication(numberOfrecords);
        insert indications;
        
    }
    
    @isTest
    static void restrictInsertionTest(){
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        List<Indication__c> indications = [select Id from Indication__c limit 1];
        Integer numberOfrecords = 1;
        
        List<Project_Indication__c> projectIndications = UtilData.createProjectIndication(projects, indications, numberOfrecords);
        
        try{
            insert projectIndications;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
        
        Integer expected = 1;
        Integer actual = [select count() from Project_Indication__c];
        System.assertEquals(expected, actual);
    }
    
    @isTest
    static void restrictUpdationTest(){
        
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        List<Indication__c> indications = [select Id from Indication__c limit 1];
        Integer numberOfrecords = 1;
         
        List<Project_Indication__c> projectIndications = UtilData.createProjectIndication(projects, indications, numberOfrecords);
        
        insert projectIndications;
        
        projectIndications[0].IsIndicationDuplicateInProjGrp__c  = true;
        
        try{
            update projectIndications;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
        
        Integer expected = 1;
        Integer actual = [select count() from Project_Indication__c];
        System.assertEquals(expected, actual);
        
    }
    
    @isTest
    static void restrictDelectionTest(){
       
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        List<Indication__c> indications = [select Id from Indication__c limit 1];
        Integer numberOfrecords = 1;
        
        List<Project_Indication__c> projectIndications = UtilData.createProjectIndication(projects, indications, numberOfrecords);
        
        insert projectIndications;
        try{
            delete projectIndications;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
        
        Integer expected = 0;
        Integer actual = [select count() from Project_Indication__c];
        System.assertEquals(expected, actual);  
    }
    
    
    
      
}