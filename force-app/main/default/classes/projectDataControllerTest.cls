/*********************************************************************************************************************
    ClassName projectDataControllerTest
    Purpose: This is a test class used to test the projectDataController functionality.
    AUTHOR : Nidhi Chouksey
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class projectDataControllerTest {
    public projectDataControllerTest() {}


    @isTest private static void getAddressDetailsTest(){
        Integer numberOfrecords = 1;

        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        insert createAccountsList;

        System.Test.startTest();
           projectDataController.projectData(createAccountsList[0].id);
        System.Test.stopTest();
    }
}