/*********************************************************************************************************************
    ClassName ParentChildRelatedRecordsTest
    Purpose: This is a test class used to test the ParentChildRelatedRecords functionality.
    AUTHOR : G Soundarya
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class ParentChildRelatedRecordsTest {
    public ParentChildRelatedRecordsTest() {    }


    @isTest
    private static void parentChildTest(){
        test.startTest();
        ParentChildRelatedRecords.getRelatedRecords();
        test.stopTest();
    }
}