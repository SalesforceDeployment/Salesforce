public with sharing class projectDataController {
    @AuraEnabled
    public static List<Project__c> projectData(Id accconId) {
        System.debug('return Project '+accconId);
        System.debug('return Project 1'+ [select id, Name,Organisation__c FROM Project__c WHERE Organisation__c=:accconId]);
        return [select id, Name,Organisation__c,Project_Group__c FROM Project__c WHERE Organisation__c=:accconId AND Project_Status__c='Live'];
    }
   
}