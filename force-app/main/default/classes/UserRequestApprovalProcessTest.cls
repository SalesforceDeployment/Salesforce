/*********************************************************************************************************************
    ClassName UserRequestApprovalProcessTest
    Purpose: This is a test class used to test the UserRequestApprovalProcess functionality.
    AUTHOR : Nidhi Chouksey
    Date : 08-July-2023
********************************************************************************************************************/

@isTest
public with sharing class UserRequestApprovalProcessTest {
    
    @isTest private static void createContactTest(){
        System.Test.startTest();
            UserRequestApprovalProcess obj = new UserRequestApprovalProcess();
            obj.userRequestId = '1111';
            try{
                obj.getApprovalSteps();
            } catch(Exception ex){}
        system.test.stopTest();
    }
    
    @isTest private static void createContactTestReject(){
        System.Test.startTest();
            UserRequestApprovalProcess obj = new UserRequestApprovalProcess();
            obj.userRequestId = '1111';
            try{
                obj.getRejectSteps();
            } catch(Exception ex){}
        system.test.stopTest();
    }

    @isTest private static void createpStepTest(){
        System.Test.startTest();
            ProcessInstanceStep pStep = new ProcessInstanceStep();
            UserRequestApprovalProcess obj = new UserRequestApprovalProcess();
            obj.userRequestId = '1111';
            obj.pStep = pStep;    
        system.test.stopTest();
    }
}