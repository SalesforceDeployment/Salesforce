/*
Author : Saroja Rekewar
Description : Community users login using rest API
*/
@RestResource(urlMapping='/CommunityLoginAPI/*')
global without sharing class CommunityLoginAPI { 
    
    /*
* Validate User login
* @param username : Login User Username
* @param password : Login User Password
* @param domain : Login domain instance ('login' for a prod/dev instance) and ('test' for a sandbox instance)
* @return 
*/
    @HttpGet
    global static void login() {
        String jsonData = RestContext.request.params.get('jsonString');
        system.debug('inside jsonData-->'+jsonData);
        Id jobId = system.enqueueJob(new SummaryOfApplicationQueueable(jsonData));
    }    
}