/*********************************************************************************************************************
    ClassName MockClass
    Purpose: This is a test class used to test the Callouts functionality and sends dummy response.
    AUTHOR : Nidhi Chouksey
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
global class MockClass implements HttpCalloutMock{
    //start of class
    public String body;
    public Integer code;
    
    public MockClass(String body,Integer code){
        body = body;
        code = code;
    }
    
    global HttpResponse respond(HTTPRequest req){
    
        // Optionally, only send a mock response for a specific endpoint and method.
        System.assertEquals('https://example.com/example/test', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(body);
        res.setStatusCode(code);
        return res;
    }
}