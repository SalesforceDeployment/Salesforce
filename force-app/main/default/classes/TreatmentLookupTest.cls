@isTest
public class TreatmentLookupTest {
    
    @testSetup 
    static void setup() {
        
        Integer numberOfrecords = 3;
        
        List<Care_Products__c> careProducts = UtilData.createCareProducts(numberOfrecords);
        insert careProducts;
        
        List<Project_Group__c> ProjectGroups = UtilData.createProjectGroupsTreatmentLookup(careProducts);
        insert ProjectGroups;
        
        List<Account> accounts = UtilData.createAccountsList(numberOfrecords);
        insert accounts;

        List<project__c> projects = UtilData.createProjects(ProjectGroups);
        for(project__c prj : projects){
            prj.No_of_weeks_treatment__c = 3;
          }
        insert projects;
        
        List<Indication__c> indications = UtilData.createIndications(projects);
        insert indications;
        for(Indication__c obj :indications){
            system.debug('obj :: ' + obj);
        }
        
        List<Project_Country__c> projectCountries = UtilData.createProjectCountries(projects);
        insert projectCountries;
        
        List<Project_Country_Indication__c > projectIndicationCountries = UtilData.createProjectCountryIndications(indications,projectCountries);
        insert projectIndicationCountries;
        

        Project_Country_Indication_Dosing__c ProjectCountryIndicationDosing = UtilData.createProjectCountryIndicationDosing(projectIndicationCountries[0].id);
        insert ProjectCountryIndicationDosing;

        List<Institution_Treatment__c> institutionTreatmentList = UtilData.createInstitutionTreatmentList(accounts,ProjectGroups);
		insert institutionTreatmentList;
        
        List<Project_Indication__c> projectIndications = UtilData.createProjectIndications(projects,indications);
        insert projectIndications;
        
        List<Project_Country_Eligibility__c> projectCountryEligibilityList = UtilData.createProjectCountryEligibilities(projectCountries);
        insert projectCountryEligibilityList;
        
        List<Dosing_Detail__c> dosingDetailsList = UtilData.createDosingDetails(indications);
        insert dosingDetailsList;
        
		List<Institution_Treatment_Indication__c> institutionTreatmentIndicationList = UtilData.createInstitutionTreatmentIndicationList(institutionTreatmentList,indications);
		insert institutionTreatmentIndicationList; 
        

        List<Treatment_Access_Request__c> treatmentAccessRequests = UtilData.CreateTreatmentAccessRequests(numberOfrecords, ProjectGroups, accounts);
        insert treatmentAccessRequests;
        
        /*List<Project_Eligibility__c> projEligiblityList = UtilData.createProjectEligiblityList(projects);
        insert projEligiblityList;*/
    }
    
    @isTest
    static void getAllindicationTest(){
        Account institution = [select Id from Account limit 1];
        System.Test.startTest();
        TreatmentLookup.WrapperTreatmentLookup wrapperObj = new TreatmentLookup.WrapperTreatmentLookup();
        TreatmentLookup.getAllindication(institution.Id);
        System.Test.stopTest();
    }
    
    @isTest
    static void getpassedIndicationTest(){
        Project_Country_Indication__c indication = [select Id from Project_Country_Indication__c limit 1];
        system.debug('indication 1111:::' +indication);

        Project__c project = [select Id from Project__c limit 1];
        System.Test.startTest();
        TreatmentLookup.getpassedIndication(indication.Id);
        System.Test.stopTest();
    }
    
    @isTest
    static void getCountryDropdownTest(){
        Account institution = [select Id from Account limit 1];
        System.Test.startTest();
        TreatmentLookup.getCountryDropdown(institution.Id);
        System.Test.stopTest();
    }
    
    @isTest
    static void getCountryDetailsTest(){
        Project_Country_Indication__c indication = [select Id from Project_Country_Indication__c limit 1];
        system.debug('indication :::' +indication);
        Project__c project = [select Id from Project__c limit 1];
        System.Test.startTest();
        TreatmentLookup.getCountryDetails(indication.Id);
        System.Test.stopTest();
    }
    
    @isTest
    static void getCountryIncEligibilityDataTest(){
        Project_Country_Indication__c projectCountryIndication = [select Id from Project_Country_Indication__c limit 1];
        System.Test.startTest();
        TreatmentLookup.getCountryIncEligibilityData(projectCountryIndication.Id);
        TreatmentLookup.getCountryExEligibilityData(projectCountryIndication.Id);
        TreatmentLookup.getCountyDosingData(projectCountryIndication.Id);
        System.Test.stopTest();
    }
    
    @isTest
    static void getNotAccessProductTest(){
        Account account = [select Id from Account Limit 1];
        System.Test.startTest();
        TreatmentLookup.getNotAccessProduct(account.Id);
        System.Test.stopTest();
    }
    
    @isTest
    static void getProductDetailsTest(){
        Institution_Treatment__c InstitutionTreatment = [select Id, Institution__c from Institution_Treatment__c limit 1];
        Care_Products__c careProducts = [select Id from Care_Products__c limit 1];
        System.Test.startTest();
        TreatmentLookup.getProductDetails(careProducts.Id, InstitutionTreatment.Institution__c);
        System.Test.stopTest();
    }
    
    @isTest
    static void treatmentRequestAccessdataTest(){
        List<Id> projectGroupIds = new List<Id>();
        for(Project_Group__c grp : [SELECT Id FROM Project_Group__c]) {
            projectGroupIds.add(grp.Id);
        }

        System.Test.startTest();
        TreatmentLookup.treatmentRequestAccessdata(projectGroupIds);
        System.Test.stopTest();
    }
    
    @isTest
    static void treatmentRequestAccessTest(){
        Account hospitalId = [select Id from Account Limit 1];
        Project_Group__c treatmentId = [select Id from Project_Group__c limit 1];
        
        System.Test.startTest();
        TreatmentLookup.treatmentRequestAccess(treatmentId.Id, hospitalId.Id);
        System.Test.stopTest();
    } 
    
    @isTest
    static void getProductTreatmentDetailsTest(){
        Account hospitalId = [select Id from Account Limit 1];
        Care_Products__c careProduct = [select Id from Care_Products__c Limit 1];
        Project_Group__c pgroup = [select Id from Project_Group__c limit 1];
        Project__c proj = [select Id,Project_Status__c from Project__c limit 1];
        proj.Project_Status__c = 'Draft in Review';
        update proj;
        proj.Project_Status__c = 'Draft Project Approved';
        update proj;
        proj.Project_Status__c = 'Live';
        update proj;

        List<Project_Country__c> prjContList = [Select id,Project__c,Project__r.Project_Group__c from  Project_Country__c];
        for(Project_Country__c obj : prjContList){
            System.debug('PRj Country'+ obj);
        }
        List<Institution_Treatment__c> instituteTreatments = [select id,Treatment__c from Institution_Treatment__c where Institution__c  = :hospitalId.Id];
        delete instituteTreatments;
        System.Test.startTest();
        TreatmentLookup.getProductTreatmentDetails( careProduct.Id, hospitalId.Id);
        TreatmentLookup.WrapperTreatmentLookup tw = new TreatmentLookup.WrapperTreatmentLookup();
        String s = '' + tw.countryIndication;
        s = '' + tw.indication;
        s = '' + tw.isProductExists;
        s = '' + tw.project;
        s = '' + tw.projectCountryList;
        s = '' + tw.projectGroup;
        s = '' + tw.careProducts;
        System.Test.stopTest();
        
    }
}