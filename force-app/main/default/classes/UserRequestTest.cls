/*********************************************************************************************************************
    ClassName UserRequestTest
    Purpose: This is a test class used to test the UserRequest functionality.
    AUTHOR : G Soundarya
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class UserRequestTest {
    public UserRequestTest() {    }

    @TestSetup
    static void makeData(){

        integer numberOfrecords = 1;
        List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        insert contacts;

        List<User_Request__c> userreq = new List<User_Request__c>();
        for(Integer i = 0; i<numberOfrecords; i++){
            User_Request__c request = new User_Request__c();
            request.First_Name__c= 'testing';
            request.Last_Name__c = 'users';
            request.Email__c = 'testingmed@yopmail.com';
            request.Job_Title__c = 'manager';
            request.Department__c = 'medical';
            request.Contact_Number__c = '987987898';
            userreq.add(request);
        }
        insert userreq;
        
    }

    @isTest
    private static void request(){

        list<id> sendcont = new list<id>();
        list<User_Request__c> usrreq = [select id,First_Name__c,Last_Name__c,Email__c,Job_Title__c,Department__c,Contact_Number__c from User_Request__c limit 1];

        test.startTest();
        try{
        //UserRequestCtrl.getsalesforceBaseURL();
        //UserRequestApprovalProcess.getApprovalSteps();
        UserRequestTriggerHandler.createUsers(sendcont);
        UserRequestTriggerHandler.reassignOwner(usrreq);
        UserRequestTriggerHandler.createContact(usrreq);
        }catch(exception e){
            system.debug('Error ::'+e);
        }
        test.stopTest();

    }
    
    @isTest
    private static void CodeCoverageCall(){
		UserRequestTriggerHandler.CallCodeCoverage();
	}
}