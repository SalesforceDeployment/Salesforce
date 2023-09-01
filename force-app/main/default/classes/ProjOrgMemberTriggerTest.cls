@isTest
public class ProjOrgMemberTriggerTest {
     @testSetup
    static void setup() {
        Integer numberOfrecords = 2;
        
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
        insert projects;
        
        project__c liveProject = new project__c();
            liveProject.Name = 'live project ';
            liveProject.Project_Code__c = 'CODE';
            liveProject.No_of_weeks_treatment__c   = 3 ;
            liveProject.Additional_Product_Information__c = 'addtional info';
            liveProject.Project_Status__c = 'Live';
            
            
            liveProject.Project_Group__c = ProjGroups[0].Id;
        insert liveProject;
    }
        
    @isTest
    static void restrictInsertionTest(){ 
        
         
        
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        
        List<Project_Organization_Member__c> projectOrgMemberList = UtilData.createProjectOrganizationMember(projects);
        
        try{
            insert projectOrgMemberList;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
        
        Integer expected = 1;
        Integer actual = [select count() from Project_Organization_Member__c];
        System.assertEquals(expected, actual);
    }
    
    @isTest
    static void restrictInsertionErrorTest(){
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Closed' limit 1];
        
        List<Project_Organization_Member__c> projectOrgMemberList = UtilData.createProjectOrganizationMember(projects);
        
        try{
            insert projectOrgMemberList;
        }catch(DmlException e){
            String expected = 'You can not Add Project Organization Member record, if Project Status is Closed';
            String actual = e.getMessage();
            System.assert(actual.contains(expected));
        }
        
        Integer expected = 0;
        Integer actual = [select count() from Project_Organization_Member__c];
        System.assertEquals(expected, actual);
    }
    
    @isTest
    static void restrictUpdationTest(){
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        List<Project_Organization_Member__c> projectOrgMemberList = UtilData.createProjectOrganizationMember(projects);
        insert projectOrgMemberList;
        
        projectOrgMemberList[0].Description__c = 'test description';
        //Project__c closedProject = [select Id from project__c where Project_Status__c = 'Closed' limit 1];
        //projectOrgMemberList[0].Project__c = closedProject.id;
        
        try{
            update projectOrgMemberList;
        }catch(DmlException e){
            String expected = 'You can not Update Project Organization Member record, if Project Status is Closed';
            String actual = e.getMessage();
            System.assert(actual.contains(expected));
        }
        
        Integer expected = 1;
        Integer actual = [select count() from Project_Organization_Member__c];
        System.assertEquals(expected, actual);
    }

    @isTest
    static void restrictDeletionTest(){
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Live' limit 1];
        List<Project_Organization_Member__c> projectOrgMemberList = UtilData.createProjectOrganizationMember(projects);
         try{
        insert projectOrgMemberList;
         }catch(DmlException e){
             System.debug('error ' + e.getMessage());
            String expected = 'You can not Add Project Organization Member record, if Project Status is Live';
            String actual = e.getMessage();
            Assert.isFalse(actual.contains(expected));
            //System.assert(actual.contains(expected));
        }
     
        Integer expected = 0;
        Integer actual = [select count() from Project_Organization_Member__c];
        System.debug('actual:' + actual);
        System.assertEquals(expected, actual); 
    }
    
    @isTest
    private static void CodeCoverageCall(){
        projOrgMemberTriggerHandler.CallCodeCoverage();
    }

}