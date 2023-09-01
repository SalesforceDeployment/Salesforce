/*********************************************************************************************************************
ClassName  UserAuthenticationTest
Purpose: This is a test class used to test the UserAuthentication functionality.
AUTHOR : Nidhi Chouksey
Date : 09-July-2023
********************************************************************************************************************/

@isTest
public with sharing class GenerateApprovalProcessTest {

    public class ApprovalCalloutMock implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('Success');
            return res;
        }
    }

    private static testMethod void createApprovalProcessTest(){
        Test.startTest();
            try{
                Test.setMock(HttpCalloutMock.class, new ApprovalCalloutMock());
                GenerateApprovalProcess.createApprovalProcess();
             } catch(Exception ex){}
        test.stopTest();
    }

    private static testMethod void handleSaveResultsTest(){
        MetadataService.SaveResult saveresult = new MetadataService.SaveResult();
        saveresult.errors = new List<MetadataService.Error>();
        MetadataService.Error errObj = new MetadataService.Error();
        saveresult.errors.add(errObj);
        saveresult.fullName = 'TestApp';
        saveresult.success = false;
        Test.startTest();
            try{
                GenerateApprovalProcess.handleSaveResults(saveresult);
            } catch(Exception ex){}
        test.stopTest();
    }
}