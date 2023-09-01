@isTest
public class ProjectSupportingInfoReqTriggerTest {
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
        
        List<Project_Supporting_Information__c> projectSuportingInformationList = UtilData.createProjectSuportingInformation(projects);
        
        try{
            insert projectSuportingInformationList;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
        
        Integer expected = 1;
        Integer actual = [select count() from Project_Supporting_Information__c ];
        System.assertEquals(expected, actual);  
    }
    
    @isTest
    static void restrictInsertionErrorTest(){ 
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Closed' limit 1];
        
        List<Project_Supporting_Information__c> projectSuportingInformationList = UtilData.createProjectSuportingInformation(projects);
        
        try{
            insert projectSuportingInformationList;
        }catch(DmlException e){
            String expected = 'You can not Add Project Supporting Information Document record, if Project Status is Closed';
            String actual = e.getMessage();
            System.assert(actual.contains(expected));
        }
        
        Integer expected = 0;
        Integer actual = [select count() from Project_Supporting_Information__c ];
        System.assertEquals(expected, actual);  
    }
    
    
    @isTest
    static void restrictUpdationTest(){
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];  
        List<Project_Supporting_Information__c> projectSuportingInformationList = UtilData.createProjectSuportingInformation(projects);
        insert projectSuportingInformationList;
        
        Project__c closedProject = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        projectSuportingInformationList[0].Project__c = closedProject.id;
        
        try{
            update projectSuportingInformationList;
        }catch(DmlException e){
            String expected = 'You can not Update Project Supporting Information Document record, if Project Status is Closed';
            String actual = e.getMessage();
            System.assert(actual.contains(expected));
        }
        
        Integer expected = 1;
        Integer actual = [select count() from Project_Supporting_Information__c];
        System.assertEquals(expected, actual);
    }
    
    @isTest
    static void restrictDeletionTest(){
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];  
        List<Project_Supporting_Information__c> projectSuportingInformationList = UtilData.createProjectSuportingInformation(projects);
        insert projectSuportingInformationList;
        
        try{
            delete projectSuportingInformationList;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
        
        Integer expected = 0;
        Integer actual = [select count() from Project_Supporting_Information__c];
        System.assertEquals(expected, actual); 
    }
}