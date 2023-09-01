/*********************************************************************************************************************
    ClassName LWCExampleControllersTest
    Purpose: This is a test class used to test the LWCExampleControllers functionality.
    AUTHOR : G Soundarya
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class LWCExampleControllersTest {
    public LWCExampleControllersTest() {    }

    @TestSetup
    static void makeData(){
        Account setup = new Account();
        setup.Name='testingaccounts';
        setup.BillingStreet = 'Test Street';
        setup.BillingCity = 'Test City';
        setup.BillingState = 'Delhi';
        setup.BillingCountry = 'India';
        setup.BillingPostalCode = '000000';
        setup.Due_Diligence_Complete__c=true;
        insert setup;
    }
    @isTest
    private static void lwcexample(){

        String sample = 'AA Research Center';
        test.startTest();
        LWCExampleControllers.retriveAccs('testingaccounts');
        test.stopTest();
    }

}