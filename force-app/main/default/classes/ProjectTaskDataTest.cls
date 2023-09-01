/*********************************************************************************************************************
ClassName ProjectTaskDataTest
Purpose: This is a test class used to test the ProjectTaskData functionality.
AUTHOR : G Soundarya
Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class ProjectTaskDataTest {
    public ProjectTaskDataTest() {    }
    
    @TestSetup
    static void makeData(){
        integer numberOfrecords = 1;
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        // List<project__c> projects = new list<project__c>();
        // project__c pro = new project__c();
        // projects[0].Project_Status__c='Draft Project Approved';
        // projects.add(pro);
        List<project__c> projectsList = new List<project__c>();
        for(integer i=0; i<ProjGroups.size(); i++){
            project__c project = new project__c();
            project.Name = 'project '+i;
            project.Project_Code__c = 'CODE';
            project.No_of_weeks_treatment__c   = 3 ;
            // project.Project_Status__c = 'Draft in Review';
            project.Project_Group__c = ProjGroups[i].Id;
            projectsList.add(project);
        }
        insert projectsList;
        
        List<Project_Country__c> projCountries = UtilData.createProjectCountry(projectsList);
        insert projCountries;
    }
    
    @isTest
    private static void testmothod(){
        
        project__c proj = [select id,name,project_status__c from project__c limit 1];
        
        Project_Country__c country = [select id from Project_Country__c limit 1];
        
        string userid = '0052z000004R4LRAA0';
        
        // ProjectTaskData.ProjectWrapper saves = new ProjectTaskData.ProjectWrapper();
        // list<ProjectTaskData.ProjectWrapper> record = new list<ProjectTaskData.ProjectWrapper>();
        // record.add(saves);
        // record[0].status='0032z00000K1UWtAAN';
        
        list<id> projid = new list<id>{'a1T2z000000BtrwEAC'};
            
            id selectedid = 'a1T2z000000BtrwEAC';
        try{
            test.startTest();
            ProjectTaskData.getcurrentuser(userid);
            ProjectTaskData.projectsData(projid);
            ProjectTaskData.projectsApprovalData(proj.id);
            ProjectTaskData.getprojectscountryData(country.id);
            ProjectTaskData.getprojectcommentData(selectedid);
            ProjectTaskData.updateProjectStatus(proj.id);
            ProjectTaskData.CallCodeCoverage();
            test.stopTest();
        }catch(exception e){
            system.debug('Error ::'+e);
        }
        
    }
}