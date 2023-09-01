public with sharing class AdminTreatmentLookup {

  @AuraEnabled(cacheable=true)
  public static List<WrapperTreatmentLookup> getAllindication() {
        List<WrapperTreatmentLookup> careWrapperList = new List<WrapperTreatmentLookup>();
        Set<Id> projectGrpIds = new Set<Id>();
        Set<Id> projectIds = new Set<Id>();
      //for(Indication__c indication : [SELECT  Id,Name from Indication__c where Id=:indicationId]){
     for(Project_Indication__c indication : [SELECT Id, name,Indication__r.Indication_Name__c, Project__r.Id,Project__r.Name, Project__r.Project_Group__r.Id, Project__r.Project_Group__r.Name, Project__r.Project_Group__r.Care_Product__r.Id,Project__r.Project_Group__r.Care_Product__r.Name from Project_Indication__c where Project__r.Project_Status__c = 'Live' AND Project__r.Id != null AND Project__r.Project_Group__r.Id != null AND Project__r.Project_Group__r.Care_Product__r.Id != null ORDER BY Project__r.Project_Group__r.Care_Product__r.Name, Project__r.Project_Group__r.Name ASC]){
            if(indication != null){
                WrapperTreatmentLookup careWrapper = new WrapperTreatmentLookup();
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



    @AuraEnabled(cacheable=true)
    public static WrapperTreatmentLookup getpassedIndication(Id indicationId) {
        WrapperTreatmentLookup careWrapper = new WrapperTreatmentLookup();
        Id countryId;
        System.debug('Varun Indication Name'+indicationId);
        //for(Indication__c indication : [SELECT Id, name, Project__r.Id,Project__r.Name, Project__r.Project_Group__r.Id, Project__r.Project_Group__r.Name, Project__r.Project_Group__r.Care_Product__r.Id,Project__r.Project_Group__r.Care_Product__r.Name from Indication__c where Project__r.Id != null AND Project__r.Project_Group__r.Id != null AND Project__r.Project_Group__r.Care_Product__r.Id != null AND Id=:indicationId]){
        Project_Indication__c  indication = [SELECT  Id,Name, Indication__r.Indication_Name__c, Project__r.Project_Group__r.Care_Product__r.Name, Project__r.Organisation__r.Name,Indication__r.Id from Project_Indication__c where Id =: indicationId];
           System.debug('Varun Indication Name'+indication);
                if(indication != null){
                    careWrapper.indication = indication;
                    careWrapper.project = indication.Project__r;
                    careWrapper.projectGroup = indication.Project__r.Project_Group__r;
                    careWrapper.careProducts = indication.Project__r.Project_Group__r.Care_Product__r;
            }


        System.debug('Varun Indication Name'+careWrapper);
        return careWrapper;
  }

  @AuraEnabled
  public static List<Project_Country_Indication__c> getCountryDetails(Id indicationId){
    System.debug('Indication Id'+ indicationId);
    List<Project_Country_Indication__c> projectCountryIndicationList = new List<Project_Country_Indication__c>();
    List<Project_Indication__c>  projectIndicationList = new List<Project_Indication__c>();
    Id projectId;
      String actualIndicationId = '';
    System.debug('Data1'+ indicationId);
     try {
        if(indicationId != null){
            projectIndicationList =  [SELECT Id, Name, Project__c, Indication__c FROM Project_Indication__c Where Id  =: indicationId];
        }
        System.debug('Data2'+ projectIndicationList);
        if(!projectIndicationList.isEmpty()){
            projectId = projectIndicationList[0].Project__c;
            actualIndicationId = projectIndicationList[0].Indication__c;
        }
        System.debug('Data3'+ projectId);
        if(projectId != null){
            projectCountryIndicationList = [SELECT Id, Country__c,Project_Country__r.Id, Email__c,Fax__c,Telephone__c,Show_Eligibility_In_Treatment_Lookup__c, Project__c FROM Project_Country_Indication__c where ProjectRecordID__c =:projectId AND Indication__c=:actualIndicationId];
        }
        System.debug('Data4'+ projectCountryIndicationList);
        } catch (Exception e) {
         throw new AuraHandledException(e.getMessage());
     }

     System.debug('Data 4' + projectCountryIndicationList);
     return projectCountryIndicationList;
  }

  // Get
  @AuraEnabled
  public static List<Project_Country_Eligibility__c> getCountryEligibilityData(Id countryIndicationId){
    System.debug('Indication Id'+ countryIndicationId);
    List<Project_Country_Indication__c> projectCountryIndicationList = new List<Project_Country_Indication__c>();
    List<Project_Country_Eligibility__c> projectCountryEligibility = new List<Project_Country_Eligibility__c>();
    Id countryId;
     try {
        if(countryIndicationId != null){
            projectCountryIndicationList =  [Select Id, Project_Country__c, Project_Country__r.Id From Project_Country_Indication__c where id  =: countryIndicationId];
        }
        if(!projectCountryIndicationList.isEmpty()){
            countryId = projectCountryIndicationList[0].Project_Country__r.Id;
        }
        if(countryId != null){
            projectCountryEligibility = [SELECT Id, Project_Country__c, Question__c, Eligibility_Type__c from Project_Country_Eligibility__c where Project_Country__c  =: countryId];
        }

    } catch (Exception e) {
         throw new AuraHandledException(e.getMessage());
     }
     if(!projectCountryEligibility.isEmpty()){
        return projectCountryEligibility;
    }else{
        return null;
    }
}


@AuraEnabled
  public static List<Project_Country_Indication_Dosing__c> getCountyDosingData(Id CountryindicationId){
    List<Project_Country_Indication_Dosing__c> dosingDetailList = new List<Project_Country_Indication_Dosing__c>();
    List<Project_Country_Indication__c> country_IndicationList = new List<Project_Country_Indication__c>();
    Id IndicationId;
    //Changed Mapping for country with project country indication rule....
    id projectcountryindication;
    system.debug('CountryindicationId '+CountryindicationId);
      try {
        if(CountryindicationId != null){
            country_IndicationList = [Select Id, Project_Country__c, Indication__r.Id, Project_Country__r.Id From Project_Country_Indication__c where Id = : CountryindicationId];
        }
        if(!country_IndicationList.isEmpty()){
            IndicationId = country_IndicationList[0].Indication__r.Id;
            projectcountryindication = country_IndicationList[0].id;
        }
        system.debug('>>>>>');
        if(IndicationId != null){
          //Changed Mapping for country with project country indication ....
          // dosingDetailList = [select id, name, Strength__c  from Dosing_Detail__c where Indication__r.Id  =: IndicationId];
          dosingDetailList = [select id, name, Strength__c  from Project_Country_Indication_Dosing__c where Project_Country_Indication__c   =:CountryindicationId];

        }


    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
    if(!dosingDetailList.isEmpty()){
        return dosingDetailList;
    }else{
        return null;
    }
  }



  @AuraEnabled
  public static List<Dosing_Detail__c> getGlobalDosingDeta(Id projectIndicationId){
    List<Dosing_Detail__c> dosingDetailList = new List<Dosing_Detail__c>();
   // List<Project_Country_Indication_Dosing__c> dosingDetailList = new List<Project_Country_Indication_Dosing__c>();
      List<Project_Indication__c> projectIndicationList = new List<Project_Indication__c>();
    Id IndicationId;
    try {
        if(projectIndicationList != null){
            projectIndicationList = [Select Id, Name, Indication__c, Indication__r.Id  from Project_Indication__c where Id  = : projectIndicationId];
        }
        if(!projectIndicationList.isEmpty()){
            IndicationId = projectIndicationList[0].Indication__r.Id;
        }
        if(IndicationId != null){
          dosingDetailList = [Select Id, Name , Strength__c,Indication__r.name, Indication__r.Id, Indication__r.Project__r.Id from Dosing_Detail__c where Indication__c  =: IndicationId];

        //dosingDetailList = [Select Id, Name , Strength__c from Project_Country_Indication_Dosing__c where Project_Country_Indication__r.Indication__c  =: IndicationId];
       // if(!dosingDetailList.isEmpty()){
            
        // }else{
        //     return null;
        // }
        }
        return dosingDetailList;
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static List<Project_Eligibility__c> getGlobalEligibalData(Id projectIndicationId){
    List<Project_Indication__c> projectIndicationList = new List<Project_Indication__c>();
    List<Project_Eligibility__c> projectEligibility = new List<Project_Eligibility__c>();
    Id projectId;
    try {
        if(projectIndicationId != null){
            projectIndicationList = [Select Id, Name, Project__r.Id from Project_Indication__c where Id = : projectIndicationId];
        }

        if(!projectIndicationList.isEmpty()){
            projectId = projectIndicationList[0].Project__r.Id;
        }
        if(projectId != null){
            projectEligibility = [select id, Eligibility_Type__c,Question__c from Project_Eligibility__c  Where Project__c =: projectId];
        }

    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
    if(!projectEligibility.isEmpty()){
        return projectEligibility;
    }else{
        return null;
    }
  }

    public class WrapperTreatmentLookup
    {
        @AuraEnabled
        public Care_Products__c careProducts{get;set;}
        @AuraEnabled
        public Project_Group__c projectGroup{get;set;}
        @AuraEnabled
        public Project__c project {get;set;}
        @AuraEnabled
        public Project_Indication__c indication{get;set;}
        @AuraEnabled
        public List<SObject> projectCountryList{get;set;}


    }

}