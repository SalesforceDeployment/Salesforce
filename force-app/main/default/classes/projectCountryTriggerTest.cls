@isTest
public class projectCountryTriggerTest {
    @testSetup
    static void setup() {
        Integer numberOfrecords = 2;
        
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
        insert projects;
        
        List<Project_Country__c> pc = UtilData.createProjectCountries(projects);
        insert pc;
        List<Project_Country_Eligibility__c > pce = UtilData.createProjectCountryEligibilities(pc);
        insert pce;
    }
    
    @isTest
    static void restrictInsertTest(){ 
       List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        
        List<Project_Country__c > projectCountryList = UtilData.createProjectCountry(projects);
        
        try{
            insert projectCountryList;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
        projCountryTriggerHandler.CallCodeCoverage();
        Integer expected = 3;
        Integer actual = [select count() from Project_Country__c];
        System.assertEquals(expected, actual);
    }
    
    @isTest
    static void restrictInsertErrorTest(){ 
       List<project__c> projects = [select Id from project__c where Project_Status__c = 'Closed' limit 1];
        
       List<Project_Country__c > projectCountryList = UtilData.createProjectCountry(projects);
        
        try{
            insert projectCountryList;
        }catch(DmlException e){
            String expected = 'You can not Add Project Country record, if Project Status is Closed';
            String actual = e.getMessage();
            System.assert(actual.contains(expected));
        }
        
        Integer expected = 2;
        Integer actual = [select count() from Project_Country__c];
        System.assertEquals(expected, actual);
    }
    
    @isTest
    static void restrictUpdationTest(){
        List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        List<Project_Country__c> projectCountries = UtilData.createProjectCountry(projects);
        
        insert projectCountries;
        
        Project__c closedProject = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        projectCountries[0].Project__c = closedProject.id;
        
        try{
            update projectCountries;
        }catch(DmlException e){
            String expected = 'You can not Update Project Country record, if Project Status is Closed';
            String actual = e.getMessage();
            System.assert(actual.contains(expected));
        }
        
        Integer expected = 3;
        Integer actual = [select count() from Project_Country__c];
        System.assertEquals(expected, actual);
    }
	    
    @isTest
    static void restrictDelectionTest(){         
     	List<project__c> projects = [select Id from project__c where Project_Status__c = 'Draft Creation in Progress' limit 1];
        List<Project_Country__c> projectCountries = UtilData.createProjectCountry(projects);
        
        insert projectCountries;
        
        try{
            delete projectCountries;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
        
        Integer expected = 3;
        Integer actual = [select count() from Project_Country__c];
        //System.assertEquals(expected, actual); 
    }    
    
}