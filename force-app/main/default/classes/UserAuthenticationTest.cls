/*********************************************************************************************************************
    ClassName  UserAuthenticationTest
    Purpose: This is a test class used to test the UserAuthentication functionality.
    AUTHOR : Nidhi Chouksey
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class UserAuthenticationTest {

    public class UserCalloutMock implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('Success');
            return res;
        }
    }

    public static testMethod void loginTest() {
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UserCalloutMock());
            UserAuthentication.login('name','pswd');
        Test.stopTest();
    }

    public static testMethod void checkUserAuthenticationTest() {
        List<UserAuthentication.InputVariable> inputVarList = new  List<UserAuthentication.InputVariable>();
        UserAuthentication.InputVariable inputVarObj = new  UserAuthentication.InputVariable();
        inputVarObj.userName = 'Test';
        inputVarObj.userPassword = 'Pswd';
        inputVarList.add(inputVarObj);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UserCalloutMock());
            UserAuthentication.checkUserAuthentication(inputVarList);
        Test.stopTest();        
    }

 
}