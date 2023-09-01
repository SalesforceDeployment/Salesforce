/*********************************************************************************************************************
    ClassName parAddressTest
    Purpose: This is a test class used to test the parAddress functionality.
    AUTHOR : G Soundarya
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class parAddressTest {
    public parAddressTest() {    }

    @isTest
    private static void methodtest(){
        test.startTest();
        parAddress.getAccountAddress();
        test.stopTest();
    }
}