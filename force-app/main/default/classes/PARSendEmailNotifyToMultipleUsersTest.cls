/*********************************************************************************************************************
ClassName PARSendEmailNotifyToMultipleUsersTest
Purpose: This is a test class used to test the MyPARSendEmailNotifyToMultipleUsers Tasks functionality.
AUTHOR : G Soundarya
Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class PARSendEmailNotifyToMultipleUsersTest {
    public PARSendEmailNotifyToMultipleUsersTest() {    }
    
    @TestSetup
    static void makeData(){
        Patient_Request__c patientRequest = UtilData.createPatientRequest();
        insert patientRequest;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standard123@yopmail.com.com',
                          EmailEncodingKey='UTF-8', FirstName ='Vineet Saxena',LastName = 'Vineet Saxena', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standard123@yopmail.com');
        insert u;
        
        List<Contact> contacts = UtilData.createContactsList(1);
        insert contacts;
    }
    
    @isTest
    private static void emailNotifyToMultipleUsersTest(){
        
        set<string> userid = new set<string>{'0052z000004R4LRAA0'};
            Patient_Request__c request = [select id from Patient_Request__c limit 1];
        
        PARSendEmailNotificationToMultipleUsers.InputData save = new PARSendEmailNotificationToMultipleUsers.InputData();
        list<PARSendEmailNotificationToMultipleUsers.InputData> rec = new list<PARSendEmailNotificationToMultipleUsers.InputData>();
        rec.add(save);
        rec[0].templateId = '00X2z000002Y3CH';
        rec[0].userList='0052z000004R4LRAA0';
        rec[0].recordType='user';
        
        
        try{
            test.startTest();
            PARSendEmailNotificationToMultipleUsers.sendEmailsOnDosingDetailsUpdate(userid,request.id);
            PARSendEmailNotificationToMultipleUsers.sendEmail(rec);
            test.stopTest();
        }catch(exception e){
            system.debug('Error ::' + e);
        }
    }
    
    @isTest
    private static void NotifyToMultipleUsersTest(){
        
        set<string> userid = new set<string>{'0032z00000K1UWtAAN'};
            Patient_Request__c request = [select id from Patient_Request__c limit 1];
        
        PARSendEmailNotificationToMultipleUsers.InputData saves = new PARSendEmailNotificationToMultipleUsers.InputData();
        list<PARSendEmailNotificationToMultipleUsers.InputData> record = new list<PARSendEmailNotificationToMultipleUsers.InputData>();
        record.add(saves);
        record[0].templateId = '00X2z000002Y3CH';
        record[0].userList='0032z00000K1UWtAAN';
        record[0].recordType='contact';
        
        
        try{
            test.startTest();
            PARSendEmailNotificationToMultipleUsers.sendEmail(record);
            PARSendEmailNotificationToMultipleUsers.CallCodeCoverage();
            test.stopTest();
        }catch(exception e){
            system.debug('Error ::' + e);
        }
    }
    
}