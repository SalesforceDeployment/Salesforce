@isTest
public class projectTriggerTest {
    
    @testSetup
    static void setup() {
        Integer numberOfrecords = 2;
        
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
    }
    
    @isTest
    static void restrictDelectionTest(){
        List<Project_Group__c> ProjGroups = [Select Id from Project_Group__c];
        List<project__c> projectList = UtilData.createProject(ProjGroups);
        insert projectList;
        
        try {
            delete projectList;
        } catch (DmlException e) {
            String expected = 'You can not delete Project if its Status is';
            String actual = e.getMessage();
            System.assert(actual.contains(expected));
        } 
    }
    
    @isTest
    static void restrictUpdationTest(){
        List<Project_Group__c> ProjGroups = [Select Id from Project_Group__c];
        
        List<project__c> projectList = UtilData.createProject(ProjGroups);
        insert projectList;
        
        for(Integer i=0; i<projectList.size(); i++){
            projectList[i].Name = 'New Name';
        }
        
        try {
            update projectList;
        } catch (DmlException e) {
            String expected = 'You can not update Project if its Status is';
            String actual = e.getMessage();
            System.assert(actual.contains(expected));
        }
    }
}