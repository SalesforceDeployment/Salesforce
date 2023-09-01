/*********************************************************************************************************************
    ClassName MyTasksTest
    Purpose: This is a test class used to test the MyTasks functionality.
    AUTHOR : G Soundarya
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class MyTasksTest {
    public MyTasksTest() {    }

    private static final String TESTUSER_EMAILENCCODEKEY= 'UTF-8';
    private static final String TIMEZONEKEY1 = 'America/Chicago';
    private static final String TESTUSER_LOCALEKEY='en_US';

    @TestSetup
    static void makeData(){
        Integer numberOfrecords = 1;
        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        insert createAccountsList;

    }   

    @isTest
    private static void taskTest(){

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standard123@yopmail.com.com',
        EmailEncodingKey='UTF-8', FirstName ='Vineet Saxena',LastName = 'Vineet Saxena', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='standard123@yopmail.com');
        insert u;
                                   
        Account acct = [select id from Account Limit 1];
        try{
        system.runAs(u)
        {
            test.startTest();
            MyTasks.getAccounts();
            MyTasks.deleteAccount(acct);
            test.stopTest();
        }
    }catch(exception e){
        system.debug(e);
    }
    }
}