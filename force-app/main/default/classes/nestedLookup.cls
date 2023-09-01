public class nestedLookup {
   
   public class Wrapper {
       @AuraEnabled
    public String projectGroupName { get; set; }
       @AuraEnabled
    public String indicationName { get; set; }
       @AuraEnabled
    public List<Dosing_Detail__c> dosingDetailList { get; set; }
       @AuraEnabled
    public List<Project_Country_Eligibility__c> projectCountryEligibilityList { get; set; }
  
    public Wrapper(String groupName, String indiName, List<Dosing_Detail__c> dosingList, List<Project_Country_Eligibility__c> eligibilityList) {
       
        this.projectGroupName = groupName;
        this.indicationName = indiName;
        this.dosingDetailList = dosingList;
        this.projectCountryEligibilityList = eligibilityList;
    }
}
@AuraEnabled
public static List<Wrapper> getNestedindi(List<Id> productIds, String userId) {
    List<Project_Country__c> projectCountryList = new List<Project_Country__c>();
    List<String> accountCountry = new List<String>(); 
    Set<Id> projecCountryInditId = new Set<Id>();
    Set<Id> IndicationtIdlist = new Set<Id>();
    List<Project_Country_Indication__c> projectCountryIndicationList = new List<Project_Country_Indication__c>();
    List<Project_Country_Eligibility__c> projectCountryEligibilityList = new List<Project_Country_Eligibility__c>();
    List<Dosing_Detail__c> dosingDetailList = new List<Dosing_Detail__c>();
    List<Wrapper> wrapperList = new List<Wrapper>();
    
    for (Account accountCount : [SELECT Id, Institution_Country__c FROM Account WHERE Id =:userId]) {
        accountCountry.add(accountCount.Institution_Country__c);
    }
    
    if (productIds != null) {                                            
        for (Project_Country__c projectcountryindication : [SELECT Id, Project__r.Project_Group__r.name, Project__r.Project_Group__c, Project__r.Project_Group__r.Care_Product__c, Project__r.Project_Status__c FROM Project_Country__c WHERE Country__c =:accountCountry AND Project__r.Project_Group__r.Care_Product__c =:productIds  AND Project__r.Project_Status__c = 'Live']) {
            projectCountryList.add(projectcountryindication); 
        }
    }
    
    if (!projectCountryList.isEmpty()) {
        for (Integer i = 0; i < projectCountryList.Size(); i++) {
            Id CountryIndication = projectCountryList[i].Id;
            projecCountryInditId.add(CountryIndication);
        }
    }
    
    if (projecCountryInditId != null) {
        projectCountryIndicationList = [SELECT Id, Name, Indication__r.Id, Indication__r.Indication_Name__c, Project_Country__r.Project__r.Project_Group__c FROM Project_Country_Indication__c WHERE Project_Country__c =:projecCountryInditId];
    }
    
    if (!projectCountryIndicationList.isEmpty()) {
        for (Integer j = 0; j < projectCountryIndicationList.Size(); j++) {
            Id indicationlistId = projectCountryIndicationList[j].Indication__r.Id;
            IndicationtIdlist.add(indicationlistId);
        }
    }
    
    if (IndicationtIdlist != null) {
    dosingDetailList = [SELECT Id, Product_Information__c, Strength__c, Default_Quantity__c, Indication__c FROM Dosing_Detail__c WHERE Indication__c =:IndicationtIdlist];
    System.debug('nestedModal dosingDetailList' + dosingDetailList);
}

if (projecCountryInditId != null) {
    projectCountryEligibilityList = [SELECT Id, Name, Eligibility_Type__c, Question__c, Project_Country__r.Project__r.Project_Group__c, Project_Country__c FROM Project_Country_Eligibility__c  WHERE Project_Country__c =:projecCountryInditId AND Project_Country__r.ShowEligibilityCriteriaInTA__c  = true];
    System.debug('nestedModal projectCountryEligibilityList' + projectCountryEligibilityList);
}



for (Project_Country__c projCountry : projectCountryList) {
    for (Project_Country_Indication__c projCountryIndication : projectCountryIndicationList) {
        if (projCountryIndication.Project_Country__c == projCountry.Id) {
            List<Dosing_Detail__c> dosingList = new List<Dosing_Detail__c>();
            for (Dosing_Detail__c dosingDetail : dosingDetailList) {
                if (dosingDetail.Indication__c == projCountryIndication.Indication__c) {
                    dosingList.add(dosingDetail);
                }
            }
            List<Project_Country_Eligibility__c> eligibilityList = new List<Project_Country_Eligibility__c>();
            for (Project_Country_Eligibility__c eligibility : projectCountryEligibilityList) {
                if (eligibility.Project_Country__c == projCountry.Id) {
                    eligibilityList.add(eligibility);
                }
            }
            Wrapper wrap = new Wrapper(projCountry.Project__r.Project_Group__r.name, projCountryIndication.Indication__r.Indication_Name__c, dosingList, eligibilityList);
            wrapperList.add(wrap);
        }
    }
}

return wrapperList;
}

   
  
 

}