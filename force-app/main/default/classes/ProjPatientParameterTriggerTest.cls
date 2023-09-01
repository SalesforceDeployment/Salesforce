@isTest
public class ProjPatientParameterTriggerTest {
    @testSetup
    static void setup(){
        Integer numberOfrecords = 2;
        
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
        insert projects;
    }
    
    @isTest
    static void restrictInsertionTest(){
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        
        List<Project_Patient_Parameter__c> projectPatientParameters = UtilData.createProjectPatientParameter(projects);
        
        try{
            insert projectPatientParameters;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
        
        Integer expected = 1;
        Integer actual = [select count() from Project_Patient_Parameter__c];
        System.assertEquals(expected, actual);
    }
    
    @isTest
    static void restrictInsertionErrorTest(){
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Closed' limit 1]; //Draft Creation in Progress
        
        List<Project_Patient_Parameter__c> projectPatientParameters = UtilData.createProjectPatientParameter(projects);
        
        try{
            insert projectPatientParameters;
        }catch(DmlException e){
            String expected = 'You can not Add Project Patient Parameter record, if Project Status is Closed';
            String actual = e.getMessage();
            System.assert(actual.contains(expected));
        }
        
        Integer expected = 0;
        Integer actual = [select count() from Project_Patient_Parameter__c];
        System.assertEquals(expected, actual);
    }
    
    @isTest
    static void restrictUpdationTest(){
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        List<Project_Patient_Parameter__c> projectPatientParameters = UtilData.createProjectPatientParameter(projects);
        
        insert projectPatientParameters;
        
        projectPatientParameters[0].Response_Type__c = 'Picklist';
        Project__c closedProject = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        projectPatientParameters[0].Project__c = closedProject.id;
        
        try{
            update projectPatientParameters;
        }catch(DmlException e){
            String expected = 'You can not Update Project Patient Parameter record, if Project Status is Closed';
            String actual = e.getMessage();
            System.assert(actual.contains(expected));
        }
        
        Integer expected = 1;
        Integer actual = [select count() from Project_Patient_Parameter__c];
        System.assertEquals(expected, actual);
        
    }
    
    @isTest
    static void restrictDelectionTest(){
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        
        List<Project_Patient_Parameter__c> projectPatientParameters = UtilData.createProjectPatientParameter(projects);
        
        insert projectPatientParameters;
        try{
            delete projectPatientParameters;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
        
        Integer expected = 0;
        Integer actual = [select count() from Project_Patient_Parameter__c];
        System.assertEquals(expected, actual); 
    }
    
    
}