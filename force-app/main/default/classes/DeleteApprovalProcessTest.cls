@isTest
public with sharing class DeleteApprovalProcessTest {
    
    public class DeleteApprovalCalloutMock implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('Success');
            return res;
        }
    }

    public static testMethod void loginTest() {
        List<DeleteApprovalProcess.Request> requestList = new  List<DeleteApprovalProcess.Request>();
        DeleteApprovalProcess.Request inputVarObj = new  DeleteApprovalProcess.Request();
        inputVarObj.id = 'Test';
        inputVarObj.name = 'Pswd';
        requestList.add(inputVarObj);
        Test.startTest();
        try{
            Test.setMock(HttpCalloutMock.class, new DeleteApprovalCalloutMock());
            DeleteApprovalProcess.execute(requestList);
        } catch(Exception ex){}
        Test.stopTest();
    }

    public static testMethod void loginTest1() {
        try{
        MetadataService.DeleteResult deleteResultObj = new MetadataService.DeleteResult();
        deleteResultObj.fullName = 'test';
        deleteResultObj.success = false;
        List<MetadataService.Error> errorList = new List<MetadataService.Error>();
        MetadataService.Error errorObj = new MetadataService.Error();
        errorObj.statusCode = '500';
        errorObj.message = 'error';
        errorList.add(errorObj);
        deleteResultObj.errors = errorList;
        Test.startTest();
            DeleteApprovalProcess.handleDeleteResults(deleteResultObj);
        Test.stopTest();
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
   
    public static testMethod void loginTest2() {
        Test.startTest();
            DeleteApprovalProcess.Response resObj = new DeleteApprovalProcess.Response();
            resObj.isSuccess = true;
            resObj.errors = 'errors';
        Test.stopTest();
    }


}