@isTest
public class accountDataControllerTest {
    
    @testSetup static void setup(){
        integer length = 4;
        List<Account> accounts = UtilData.createAccountsList(length);
        insert accounts;
        List<Contact> contacts = UtilData.createContactsList(length);
        insert contacts;
    }
    
    @isTest
    static void accountDataTest(){ 
      Account acc = [select Id, Name, BillingCity from Account where Name = 'Demo Account' limit 1];
      System.Test.startTest();
      accountDataController.accountData(acc.Id);
      System.Test.stopTest();
        
      System.assertEquals('Jaipur', acc.BillingCity);
    }
    
    @isTest
    static void accountContactDataTest(){
        Account acc = [select Id, Name, BillingCity from Account where Name = 'Demo Account' limit 1];
        
        Id crtId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Institution').getRecordTypeId();
        Contact cont = new Contact();
        cont.RecordTypeId =crtId;
        cont.LastName = 'TestLast';
        cont.AccountId = acc.Id;
        cont.Phone = '1234567890';
        cont.Email = 'test@test.com';
        cont.Role__c = 'Physician';
        cont.Validation__c = true;
        insert cont;
        
        Contact c = [select Id,LastName from contact where LastName = 'TestLast'];
        System.Test.startTest();
        accountDataController.accountContactData(c.Id);
        System.Test.stopTest();
        
        System.assertEquals('TestLast', c.LastName);
    }
    @isTest
    static void accountDataLookupTest(){
        System.Test.startTest();
        accountDataController.accountDataLookup();
        System.Test.stopTest();
        Account acc = [select Id, Name, BillingState from Account where Name = 'Demo Account' limit 1];

        
        System.assertEquals('Raj', acc.BillingState);
    }
    
    @isTest
    static void accountDataForAdminandManagersTest(){
        System.Test.startTest();
        accountDataController.accountDataForAdminandManagers();
        System.Test.stopTest();
        
        Account acc = [select Id, Name, BillingPostalCode from Account where Name = 'Demo Account' limit 1];
        System.assertEquals('302012', acc.BillingPostalCode);

    }
    
    @isTest
    static void permissionForAdminandManagersTest(){
        System.Test.startTest();
        accountDataController.permissionForAdminandManagers();
        System.Test.stopTest();
    }
    
    @isTest
    static void contacDataTest(){
        Contact c = [select Id,LastName from contact where LastName = 'Test Contact' limit 1];
        System.Test.startTest();
        accountDataController.contactData(c.Id);
        System.Test.stopTest();
        System.assertEquals('Test Contact', c.LastName);
    }
    
    @isTest
    static void UserDataTest(){
        User u = [select Id, LastName,Name,email from User Limit 1];
        System.Test.startTest();
        accountDataController.UserData(u.Id);
        System.Test.stopTest();
    }
    
    @isTest
    static void getPhysicianDataTest(){
        Account acc = [select Id, Name, BillingCity from Account where Name = 'Demo Account' Limit 1];
        Contact con = [select Id,LastName from contact where LastName = 'Test Contact' Limit 1];
       
        System.Test.startTest();
        accountDataController.getPhysicianData(acc.Id, con.Id);
        System.Test.stopTest();
    }
    
    @isTest
    static void getPhysicianDataTestNull(){
        Account acc = [select Id, Name, BillingCity from Account where Name = 'Demo Account' Limit 1];
       
        System.Test.startTest();
        accountDataController.getPhysicianData(acc.Id, null );
        System.Test.stopTest();
    }
    
    @isTest
    static void WrapperaccountDataTest(){
        Account acc = [select Id, Name, Institution_Country__c from Account where Name = 'Demo Account' Limit 1];
        AccountDataController.WrapperaccountData wrapper = new AccountDataController.WrapperaccountData();
        wrapper.account = acc;
        
        System.assertEquals('India', acc.Institution_Country__c);
    }
    
    @isTest
    static void getAccountCountryTest(){
        Account acc = [select Id, Name, Institution_Country__c from Account where Name = 'Demo Account' Limit 1];
        System.Test.startTest();
        accountDataController.getAccountCountry(acc.Id);
        System.Test.stopTest();
        
        System.assertEquals('India', acc.Institution_Country__c);
    }
    
    @isTest
    static void createApexContactsDataTest(){
        String contactInfo = '[{"Id":"001R0000003abcde","Name":"John Doe","Email":"johndoe@example.com"},{"Id":"001R000000xyz123","Name":"Jane Smith","Email":"janesmith@example.com"}]';
        System.Test.startTest();
        accountDataController.createApexContactsData(contactInfo);
        System.Test.stopTest();
        
        Contact cont = [select Id,Phone from contact where LastName = 'Test Contact' limit 1];
        System.assertEquals('1234567890', cont.Phone);
    }



    @isTest
    static void getSummaryDataTest(){

        Contact contactObj = [Select id from Contact limit 1];

        Patient_Request__c patientRequest = UtilData.createPatientRequest();
        insert patientRequest;

        System.Test.startTest();
            accountDataController.getSummaryData(patientRequest.id);
            accountDataController.getPhySicianCountryInstitutions(contactObj.id);
        System.Test.stopTest();
    }
    
}