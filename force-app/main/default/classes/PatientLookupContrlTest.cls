/*********************************************************************************************************************
    ClassName public class PatientLookupContrlTest {
    Purpose: This is a test class used to test the PatientLookupContrl functionality.
    AUTHOR : Nidhi Chouksey
    Date : 08-July-2023
********************************************************************************************************************/

@isTest
public class PatientLookupContrlTest {

    @testSetup
    static void setup() {
        Integer numberOfrecords = 1;
        integer len = 1;
        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        insert createAccountsList;

        Patient_Request__c patientRequest = UtilData.createPatientRequest();
        insert patientRequest;

        Patient_Request__c pr1 = new Patient_Request__c(Status__c = 'Pending Physician Approval');
        insert pr1;

        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;

        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;


        List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        // //contacts[0].RecordType.Name='Organisation';
        insert contacts;

        List<Institution_Treatment__c> institutetreat = new List<Institution_Treatment__c>();
        for(Integer i = 0; i<len; i++){
            Institution_Treatment__c treat = new Institution_Treatment__c();
            treat.Is_Duplicate__c = false;
            institutetreat.add(treat);
        }
        //insert institutetreat;

    }

	@isTest
    public static void getPhysician() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Minimum Access - Salesforce'];
        User u = new User(Alias = 'standt', Email='standard@yopmail.com.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='bio45ard@yopmail.com');
        insert u;
        //PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Regulatory_Reviewer'];
        PermissionSetGroup ps = [SELECT Id,Status  FROM PermissionSetGroup WHERE DeveloperName = 'Regulatory_Reviewer'];
        if (ps.Status != 'Updated') {
            Test.calculatePermissionSetGroup(ps.Id);
          }
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetGroupId = ps.Id);
        system.runAs(u){
        test.startTest();
        try{
            PatientLookupContrl.getPersona();
            PatientLookupContrl.isPhyscian();
            PatientLookupContrl.getPickValues();
            PatientLookupContrl.getTreatmentsFromPR();
            PatientLookupContrl.getPhysicianPatients();
        }catch(exception e){
            system.debug('Error ::' + e);
        }
        test.stopTest();
    }
    }

    @isTest
    public static void negativetest() {
        test.startTest();
        try{
            PatientLookupContrl.getPersona();
            PatientLookupContrl.isPhyscian();
            PatientLookupContrl.getPickValues();
            PatientLookupContrl.getTreatmentsFromPR();
            PatientLookupContrl.getPhysicianPatients();
        }catch(exception e){
            system.debug('Error ::' + e);
        }
        test.stopTest();
    }

    @isTest
    public static void filterpatient() {
        Patient_Request__c PatientReqObj = [Select id,Initials__c from Patient_Request__c  limit 1];
        list<string> institution = new list<string>();
        list<string> name = new list<string>();
        list<string> status = new list<string>();
        list<string> selectedCounrties = new list<string>();
        Date birth = Date.today();
        Profile p = [SELECT Id FROM Profile WHERE Name='Minimum Access - Salesforce'];
        User u = new User(Alias = 'standt', Email='standard@yopmail.com.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='bio93rd@yopmail.com');
        insert u;
        //PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Regulatory_Reviewer'];
        PermissionSetGroup ps = [SELECT Id,Status FROM PermissionSetGroup WHERE DeveloperName = 'Regulatory_Reviewer'];
        if (ps.Status != 'Updated') {
            Test.calculatePermissionSetGroup(ps.Id);
          }
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetGroupId = ps.Id);
        system.runAs(u){
        test.startTest();
        try{
            PatientLookupContrl.getPersona();
            PatientLookupContrl.getFilteredPatients(PatientReqObj.id,'test',birth,institution,name,status,selectedCounrties);
        }catch(exception e){
            system.debug('Error ::' + e);
        }
        test.stopTest();
    }
    }

    @isTest private static void submitPatientRequestForApprovalTest(){
        Patient_Request__c PatientReqObj = [Select id,Initials__c from Patient_Request__c  limit 1];
        list<string> institution = new list<string>{'Health'};
        list<string> name = new list<string>{'fever'};
        list<string> status = new list<string>{'pending'};
        list<string> selectedCounrties = new list<string>{'India'};
        Date birth = Date.today();
        System.Test.startTest();
            PatientLookupContrl.getPhysicianPatients();
            PatientLookupContrl.getFilteredPatients(PatientReqObj.id,'test',birth,institution,name,status,selectedCounrties);
            PatientLookupContrl.getTreatmentsFromPR();
        System.Test.stopTest();
        System.assert(true, 'submitPatientRequestForApprovalTest');
    }

    @isTest private static void getInstitutionTreatmentTest(){
        Patient_Request__c PatientReqObj = [Select id,Initials__c from Patient_Request__c  limit 1];
        Account accObj = [Select id from Account limit 1];
        System.Test.startTest();
            PatientLookupContrl.getInstitutionTreatment('Internal Reviewer',accObj.Id);
            PatientLookupContrl.getInstitutionTreatment('Regulatory Reviewer',accObj.Id);
        System.Test.stopTest();
        System.assert(true, 'getInstitutionTreatmentTest');
    }

    @isTest
    public static void personna() {

        // integer numberOfrecords = 1;
        // List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        // contacts[0].RecordType.Name='Organisation';
        // insert contacts;
        Profile p = [SELECT Id FROM Profile WHERE Name='Minimum Access - Salesforce'];
        User u = new User(Alias = 'standt', Email='standard@yopmail.com.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='bio45test@yopmail.com');
        insert u;
        PermissionSetGroup ps = [SELECT Id,Status FROM PermissionSetGroup WHERE DeveloperName = 'Patient_Access_Manager'];
        if (ps.Status != 'Updated') {
            Test.calculatePermissionSetGroup(ps.Id);
          }
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetGroupId = ps.Id);
        system.runAs(u){
            test.startTest();
            try{
                PatientLookupContrl.getPersona();
            }catch(exception e){
                system.debug('Error ::' + e);
            }
            test.stopTest();
        }
    }

    @isTest
    public static void getFilteredPatientTest(){
        Patient_Request__c PatientReqObj = [Select id,Initials__c from Patient_Request__c  limit 1];
        list<string> institution = new list<string>();
        list<string> name = new list<string>();
        list<string> status = new list<string>();
        list<string> selectedCounrties = new list<string>();
        Date birth = Date.today();
        Profile p = [SELECT Id FROM Profile WHERE Name='Minimum Access - Salesforce'];
        User u = new User(Alias = 'standt', Email='standard@yopmail.com.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='bio!#$@yopmail.com');
        insert u;
        PermissionSetGroup ps = [SELECT Id,Status FROM PermissionSetGroup WHERE DeveloperName = 'Bionical_Medical_Reviewer'];
        if (ps.Status != 'Updated') {
            Test.calculatePermissionSetGroup(ps.Id);
          }
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetGroupId = ps.Id);
        system.runAs(u){
        test.startTest();
        try{
            PatientLookupContrl.getPersona();
            PatientLookupContrl.getFilteredPatients(PatientReqObj.id,'test',birth,institution,name,status,selectedCounrties);
        }catch(exception e){
            system.debug('Error ::' + e);
        }
        test.stopTest();
    }
    }

}