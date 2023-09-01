public with sharing class TreatmentDetails {

    @AuraEnabled(cacheable=true)
  public static List<WrapperTreatmentDetails> getAllindication() {
        List<WrapperTreatmentDetails> careWrapperList = new List<WrapperTreatmentDetails>();
        Set<Id> projectGrpIds = new Set<Id>();
        Set<Id> projectIds = new Set<Id>();
        for(Indication__c indication : [SELECT Id, name, Project__r.Id,Project__r.Name, Project__r.Project_Group__r.Id, Project__r.Project_Group__r.Name, Project__r.Project_Group__r.Care_Product__r.Id,Project__r.Project_Group__r.Care_Product__r.Name from Indication__c where Project__r.Id != null AND Project__r.Project_Group__r.Id != null AND Project__r.Project_Group__r.Care_Product__r.Id != null]){
            if(indication != null){
                    WrapperTreatmentDetails careWrapper = new WrapperTreatmentDetails();
                    careWrapper.indication = indication;
                    careWrapper.project = indication.Project__r;
                    careWrapper.projectGroup = indication.Project__r.Project_Group__r;
                    careWrapper.careProducts = indication.Project__r.Project_Group__r.Care_Product__r;
                    
                    careWrapperList.add(careWrapper);
            }
        } 

        System.debug(careWrapperList);

        return careWrapperList;
  }
  


  public class WrapperTreatmentDetails
    {
        @AuraEnabled
        public Care_Products__c careProducts{get;set;}  
        @AuraEnabled
        public Project_Group__c projectGroup{get;set;}
        @AuraEnabled
        public Project__c project {get;set;}
        @AuraEnabled
        public Indication__c indication{get;set;}
 
    }
    
}