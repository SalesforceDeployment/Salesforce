public without sharing class ProjectTaskRelated {
    
    @AuraEnabled(cacheable=true)
    public static List<Project_Country__c> getProducts(Id ProjCountryId) {        
        return  [SELECT Id,Name,Country__c,Project__r.Organisation__r.Name, Project__r.Product__c,Project__r.Project_Group__r.Care_Product__c,Project__r.Project_Group__c,Project__r.Organisation__c,Project__r.Name from Project_Country__c WHERE Id =:ProjCountryId];
    }
    @AuraEnabled(cacheable=true)
    public static List<Project__c> GetProjectGroups(Id productId,Id projectIdCount) {
        return [SELECT Id, Name,Project_Group__r.Name,Project_Group__r.Id,Project_Group__r.Care_Product__c from Project__c WHERE Project_Group__r.Care_Product__c =:productId AND Id =:projectIdCount AND Project_Status__c = 'Draft in Review'];
    }
    @AuraEnabled(cacheable=true)
    public static List<Project_Country_Indication__c> GetIndication(Id projectGroupId, string accountCountry,Id projectIdCount) {
        List<Project__c> projectIdList= [SELECT Id FROM Project__c WHERE Project_Group__r.Id =: projectGroupId AND Id =:projectIdCount AND Project_Status__c ='Draft in Review'];
        List<Project_Country__c> projectCountryIdList = [SELECT Id, Name, Country__c FROM Project_Country__c WHERE Project__r.Id =: projectIdList AND Country__c =:accountCountry];
        return [SELECT Id, Name, Indication__r.Indication_Name__c, Country__c FROM Project_Country_Indication__c WHERE Project_Country__r.Id =: projectCountryIdList];
    }
    @AuraEnabled(cacheable = true)
    public static List<Project_Country_Regulatory_Consent__c> getRegulatoryConsents(String accountCountry, String projectGroupId) {
        List<Project_Country_Regulatory_Consent__c> regulatoryList = new List<Project_Country_Regulatory_Consent__c> ();
        for(Project_Country_Regulatory_Consent__c projectCountryRec: [SELECT Id, Project_Country__c, Project_Country__r.Project__r.Project_Status__c, Sequence_Order__c, Consent_Title__c, Consent_Description__c, Project_Country__r.Country__c, Project_Country__r.Project__r.Project_Group__c FROM Project_Country_Regulatory_Consent__c WHERE Project_Country__r.Country__c=:accountCountry AND Project_Country__r.Project__r.Project_Group__c=:projectGroupId AND Project_Country__r.Project__r.Project_Status__c='Draft in Review']) {
            if(projectCountryRec.Sequence_Order__c!=2) {
                regulatoryList.add(projectCountryRec);
            }
        }
        return regulatoryList;
    }
}