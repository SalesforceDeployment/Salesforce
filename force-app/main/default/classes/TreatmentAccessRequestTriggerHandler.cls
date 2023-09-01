public with sharing class TreatmentAccessRequestTriggerHandler {
    
public static void reassignOwner(List<Treatment_Access_Request__c> treatmentRequestList) {
       List<Group> groupRequestList = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name='PAM Queue'];
        system.debug('inside 7-->'+groupRequestList);
        for(Treatment_Access_Request__c treatmentRecord: treatmentRequestList) {
            treatmentRecord.OwnerId = groupRequestList.get(0)?.Id;
        }
    }
}