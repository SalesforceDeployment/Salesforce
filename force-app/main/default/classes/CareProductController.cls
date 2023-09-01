public without sharing class CareProductController {  
    @AuraEnabled(cacheable=true)
    public static List<Institution_Treatment__c> getProducts(Id instititionId) {
        return [SELECT Id, Name, Treatment__r.Name, Treatment__r.Id, Treatment__r.Care_Product__r.Id, Treatment__r.Care_Product__r.Name FROM Institution_Treatment__c WHERE Institution__r.Id = :instititionId AND Treatment__r.Care_Product__r.Is_Active__c = true];
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Institution_Treatment__c> GetProjectGroups(Id instititionId,Id productId) {
        return [SELECT Id, Name, Treatment__r.Name, Treatment__r.Id, Treatment__r.Care_Product__r.Id, Treatment__r.Care_Product__r.Name FROM Institution_Treatment__c WHERE Institution__r.Id = :instititionId AND Treatment__r.Care_Product__r.Id =:productId AND Treatment__r.Care_Product__r.Is_Active__c = true AND Treatment__r.Status__c = 'Live'];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Project_Country_Indication__c> GetIndication(Id projectGroupId, string accountCountry) 
    {
        List<Project__c> projectIdList= [SELECT Id FROM Project__c WHERE Project_Group__r.Id =: projectGroupId AND Project_Status__c = 'Live'];
        
        
        List<Project_Country__c> projectCountryIdList = [SELECT Id, Name, Country__c FROM Project_Country__c WHERE Project__r.Id =: projectIdList AND Country__c =:accountCountry];
        
        return [SELECT Id, Name, Indication__r.Indication_Name__c, Country__c FROM Project_Country_Indication__c WHERE Project_Country__r.Id =: projectCountryIdList];
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Project_Country_Indication__c> GetIndicationForEdit(Id pcIndicationId) {
        
        return [SELECT Id, Name, Indication__r.Indication_Name__c, Country__c FROM Project_Country_Indication__c WHERE Id =: pcIndicationId];
        
    }

    @AuraEnabled
    public static Boolean checkInstitutionEligibility(String instititionId, String productId, String treatmentID, String pcIndicationId)
    {
      try {
        Boolean retvalue = false;
        List<Institution_Treatment__c> insTreatmentList =  new List<Institution_Treatment__c>();
        insTreatmentList = [SELECT Id, Name, Institution__r.Institution_Country__c FROM Institution_Treatment__c WHERE 
        Institution__r.Id = :instititionId AND Treatment__r.Care_Product__r.Id =: productId AND Treatment__r.Id = :treatmentID AND Treatment__r.Care_Product__r.Is_Active__c = true];
        if(!insTreatmentList.isEmpty())
        {
          retvalue = true;
        }
        else {
          retvalue = false;
        }
        return retvalue;
      } catch(Exception ex) {
        throw new AuraHandledException(ex.getMessage());  
      }  
    }
    
}