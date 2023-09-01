public without sharing class VerifyEmailController {
    
    @AuraEnabled
    public static void verifyUserRequestEmail(string email){
        List<User_Request__c> request = [SELECT Id FROM  User_Request__c 
                                         WHERE Email__c=:email
                                         AND Email_Verified__c=false];
        if(!request.isEmpty()){
            request[0].Email_Verified__c = true;
            UPDATE request;
        } else {
            throw new AuraHandledException('Invalid request token.');
        }
    }
}