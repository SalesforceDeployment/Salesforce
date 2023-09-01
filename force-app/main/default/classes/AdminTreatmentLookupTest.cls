@isTest
public class AdminTreatmentLookupTest {

    @testSetup
    static void setup() {
        Integer numberOfrecords = 3;
        
        List<Care_Products__c> careProducts = UtilData.createCareProducts(numberOfrecords);
        insert careProducts;
        
        List<Project_Group__c> ProjectGroups = UtilData.createProjectGroups(careProducts);
        insert ProjectGroups;
        
        List<project__c> projects = UtilData.createProjects(ProjectGroups);
        for(project__c prj : projects){
          prj.No_of_weeks_treatment__c = 3;
        }
        insert projects;
        
        List<Indication__c> indications = UtilData.createIndications(projects);
        insert indications; 
        
        List<Project_Country__c> projectCountries = UtilData.createProjectCountries(projects);
        insert projectCountries;
        
        List<Project_Country_Indication__c > projectIndicationCountries = UtilData.createProjectCountryIndications(indications,projectCountries);
        insert projectIndicationCountries;
        
        List<Project_Country_Eligibility__c> projectCountryEligibilityList = UtilData.createProjectCountryEligibilities(projectCountries);
        insert projectCountryEligibilityList;
        
        List<Dosing_Detail__c> dosingDetailsList = UtilData.createDosingDetails(indications);
        insert dosingDetailsList;
        
        List<Project_Eligibility__c> projEligiblityList = UtilData.createProjectEligiblityList(projects);
        insert projEligiblityList;
        
        
        List<Project_Indication__c> projectIndications = UtilData.createProjectIndications(projects,indications);
        insert projectIndications;

    }
    
    @isTest
    static void getAllindicationTest(){ 
      System.Test.startTest();
      AdminTreatmentLookup.getAllindication();
      System.Test.stopTest();
      
      Integer expected = 3;
      Integer actual = [select count() from Project_Indication__c ];
      //System.assertEquals(projGroup.Id, projIndication.Project__r.Project_Group__r.Id);
      System.assertEquals(expected, actual);
    }
    
    @isTest
    static void getpassedIndicationTest(){
      Project_Indication__c indication = [SELECT  Id,Name, Indication_Name__c, Project__r.Project_Group__r.Care_Product__r.Name, Project__r.Organisation__r.Name,Indication__r.Id from Project_Indication__c limit 1];
      System.Test.startTest();
      AdminTreatmentLookup.getpassedIndication(indication.Id);
      System.Test.stopTest();
        
      
      //System.assertEquals('indication 0', indication.Indication_Name__c);       
    }
    
    @isTest
    static void getCountryDetailsTest(){
      Project_Indication__c indication = [SELECT  Id,Name, Indication_Name__c, Project__r.Project_Group__r.Care_Product__r.Name, Project__r.Organisation__r.Name,Indication__r.Id from Project_Indication__c limit 1];
      System.Test.startTest();
      AdminTreatmentLookup.getCountryDetails(indication.Id);
      System.Test.stopTest();
        
      Project_Country_Indication__c projCountryIndication = [SELECT Id, Country__c,Email__c,Fax__c,Telephone__c,Show_Eligibility_In_Treatment_Lookup__c, Project__c FROM Project_Country_Indication__c where ProjectRecordID__c =: indication.Project__r.Id];
      System.assertEquals('India', projCountryIndication.Country__c);       
    }
    
    @isTest
    static void getCountryEligibilityDataTest(){
        Project_Country_Indication__c projCountryIndication = [Select Id, Project_Country__c, Project_Country__r.Id From Project_Country_Indication__c limit 1];
        System.Test.startTest();
        AdminTreatmentLookup.getCountryEligibilityData(projCountryIndication.Id);
        System.Test.stopTest();
        
        Project_Country_Eligibility__c projCountryEligibility = [SELECT Id, Project_Country__c, Question__c, Eligibility_Type__c from Project_Country_Eligibility__c where Project_Country__c  =: projCountryIndication.Project_Country__r.Id];
        System.assertEquals('Inclusion Criteria', projCountryEligibility.Eligibility_Type__c);
    }
    
    @isTest
    static void getCountyDosingDataTest(){
        Project_Country_Indication__c projCountryIndication = [Select Id, Project_Country__c, Indication__r.Id, Project_Country__r.Id From Project_Country_Indication__c limit 1];
        System.Test.startTest();
        AdminTreatmentLookup.getCountyDosingData(projCountryIndication.Id);
        System.Test.stopTest();
        
        Dosing_Detail__c dosingDetail = [select id, name, Strength__c  from Dosing_Detail__c where Indication__r.Id  =: projCountryIndication.Indication__r.Id];
        System.assertEquals('Strength 0',dosingDetail.Strength__c);
    }
    
    @isTest
    static void getGlobalDosingDetaTest(){
        Project_Indication__c projIndication = [Select Id, Name, Indication__c, Indication__r.Id  from Project_Indication__c  limit 1];
        System.Test.startTest();
        AdminTreatmentLookup.getGlobalDosingDeta(projIndication.Id);
        System.Test.stopTest();
        
        Dosing_Detail__c dosingDetail = [Select Id, Name , Strength__c,Indication__r.name, Indication__r.Id, Indication__r.Project__r.Id from Dosing_Detail__c where Indication__c  =: projIndication.Indication__r.Id];
        System.assertEquals(projIndication.Indication__c,dosingDetail.Indication__c);
    }
    
    @isTest
    static void getGlobalEligibalDataTest(){
        Project_Indication__c projIndication = [Select Id, Name, Project__r.Id from Project_Indication__c limit 1];
        System.Test.startTest();
        AdminTreatmentLookup.getGlobalEligibalData(projIndication.Id);
        System.Test.stopTest();
        
        Project_Eligibility__c projEligibility = [select id, Eligibility_Type__c,Question__c from Project_Eligibility__c  Where Project__c =: projIndication.Project__r.Id];
        System.assertEquals('Inclusion Criteria',projEligibility.Eligibility_Type__c);
    }
    
    
}