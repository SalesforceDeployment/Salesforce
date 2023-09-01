public without sharing class TreatmentLookup {

    @AuraEnabled
      public static List<WrapperTreatmentLookup> getAllindication(Id hospitalId) {
        List<WrapperTreatmentLookup> careWrapperList = new List<WrapperTreatmentLookup>();
        Set<Id> projectGrpIds = new Set<Id>();
       List<String> instituteCountry = new List<String>();
        Set<Id> projectGroupIds = new Set<Id>();
        System.debug('hospitalId === '+ hospitalId);
        if(hospitalId != null){
            for(Institution_Treatment__c instituteTreatmentList :  [SELECT Id, Institution__r.Name, Country__c, Treatment__r.Id, Treatment_Name__c, Product_Name__c, Name   FROM Institution_Treatment__c Where Institution__c=: hospitalId]){
               projectGroupIds.add(instituteTreatmentList.Treatment__r.id);
            }
            for(Institution_Treatment__c instituteTreatmentCountry :  [SELECT Id, Country__c  FROM Institution_Treatment__c Where Institution__c=: hospitalId]){

                 instituteCountry.add(instituteTreatmentCountry.Country__c);
             }

        }
        System.debug('Country Institute === '+ instituteCountry);
        System.debug('projectGroupIds === '+ projectGroupIds);
        if(!projectGroupIds.isEmpty()){
            for(Project_Country_Indication__c indication : [SELECT Id, name,Country__c,Project_Country__r.Name,Project_Country__r.Project__r.Name,Project_Country__r.Project__r.Project_Group__r.Name,Project_Country__r.Project__r.Project_Group__r.Care_Product__r.Name,Indication__r.Indication_Name__c from Project_Country_Indication__c where Country__c =: instituteCountry AND Project_Country__r.Project__r.Project_Status__c = 'Live' AND Project_Country__r.Project__r.Project_Group__r.Id =: projectGroupIds AND  Project_Country__r.Project__r.Id != null AND Project_Country__r.Project__r.Project_Group__r.Id != null AND Project_Country__r.Project__r.Project_Group__r.Care_Product__r.Id != null ORDER BY Project_Country__r.Project__r.Project_Group__r.Care_Product__r.Name, Project_Country__r.Project__r.Project_Group__r.Name ASC ]){
                if(indication != null){
                    WrapperTreatmentLookup careWrapper = new WrapperTreatmentLookup();
                        careWrapper.countryIndication = indication;
                        careWrapper.project = indication.Project_Country__r.Project__r;
                        careWrapper.projectGroup = indication.Project_Country__r.Project__r.Project_Group__r;
                        careWrapper.careProducts = indication.Project_Country__r.Project__r.Project_Group__r.Care_Product__r;

                        careWrapperList.add(careWrapper);
                }
            }
        }
        System.debug('careWrapperList === '+ careWrapperList);


            return careWrapperList;
      }



        @AuraEnabled
        public static Project_Country_Indication__c getpassedIndication(String countryindicationid) {
            return [select Id,Name,Indication__r.Indication_Name__c, Product__c, Project_Country__r.Project__r.Organisation__r.Name  from Project_Country_Indication__c where Id =:countryindicationid];
         }

      @AuraEnabled
      public static List<Account> getCountryDropdown(Id hospitalId){
        List<Account> accList = new List<Account>();
        try {
            if(hospitalId != null){
                accList = [SELECT Id, name, Institution_Country__c from Account where Id =: hospitalId];
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return accList;
      }

      @AuraEnabled
      public static Project_Country_Indication__c getCountryDetails(String countryindicationid){
        return [SELECT Id, Country__c,Email__c,Fax__c,Telephone__c,Show_Eligibility_In_Treatment_Lookup__c, Project__c FROM Project_Country_Indication__c where Id =:countryindicationid];
      }

      // Get
      @AuraEnabled
      public static List<Project_Country_Eligibility__c> getCountryIncEligibilityData(Id countryIndicationId){
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
                projectCountryEligibility = [SELECT Id, Project_Country__c, Question__c, Eligibility_Type__c from Project_Country_Eligibility__c where Project_Country__c  =: countryId AND Eligibility_Type__c='Inclusion Criteria'];
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
      public static List<Project_Country_Eligibility__c> getCountryExEligibilityData(Id countryIndicationId){
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
                projectCountryEligibility = [SELECT Id, Project_Country__c, Question__c, Eligibility_Type__c from Project_Country_Eligibility__c where Project_Country__c  =: countryId AND Eligibility_Type__c='Exclusion Criteria'];
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


    // @AuraEnabled
    //   public static List<Dosing_Detail__c> getCountyDosingData(Id CountryindicationId){
    //     List<Dosing_Detail__c> dosingDetailList = new List<Dosing_Detail__c>();
    //     List<Project_Country_Indication__c> country_IndicationList = new List<Project_Country_Indication__c>();
    //     Id IndicationId;
    //     try {
    //         if(CountryindicationId != null){
    //             country_IndicationList = [Select Id, Project_Country__c, Indication__r.Id, Project_Country__r.Id From Project_Country_Indication__c where Id = : CountryindicationId];
    //         }
    //         if(!country_IndicationList.isEmpty()){
    //             IndicationId = country_IndicationList[0].Indication__r.Id;
    //         }
    //         if(IndicationId != null){
    //             dosingDetailList = [select id, name, Strength__c  from Dosing_Detail__c where Indication__r.Id  =: IndicationId];
    //         }


    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    //     if(!dosingDetailList.isEmpty()){
    //         return dosingDetailList;
    //     }else{
    //         return null;
    //     }
    //   }

      @AuraEnabled
      public static List<Project_Country_Indication_Dosing__c> getCountyDosingData(Id CountryindicationId){
        List<Project_Country_Indication_Dosing__c> dosingDetailList = new List<Project_Country_Indication_Dosing__c>();
        try {
            if(CountryindicationId != null){
                dosingDetailList = [select id, name, Strength__c from Project_Country_Indication_Dosing__c where Project_Country_Indication__c  =:CountryindicationId];
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
      public static List<Project_Group__c> getNotAccessProduct(Id hospitalId) {
        if(hospitalId != null){
            Account acc = [SELECT Id, name, Institution_Country__c from     Account where id =: hospitalId];
            List<project_country__c> projectCountries = [select id,Project__c,Project__r.Product__c,Project__r.Project_Group__r.name,Project__r.Project_Group__c from project_country__c where Country__c  = :acc.Institution_Country__c and Project__r.Project_Status__c ='Live' and Project__r.Project_Group__r.Visible_for_HCP_to_request_access__c = true];
            List<Institution_Treatment__c> treatments= [select Product_Name__c,Treatment__r.Care_Product__c,Treatment__c,Treatment__r.name from Institution_Treatment__c where Institution__c = :hospitalId];
            Set<String> approvedTreatmentSet = new Set<String>();
            for(Institution_Treatment__c treatment: treatments){
                if(!approvedTreatmentSet.contains(treatment.Treatment__c)){
                    approvedTreatmentSet.add(treatment.Treatment__c);
                }
            }
            Set<String> notApprovedtreatmentSet = new Set<String>();
            for(project_country__c projectCountry: projectCountries){
                if(!approvedTreatmentSet.contains(projectCountry.Project__r.Project_Group__c)){
                    notApprovedtreatmentSet.add(projectCountry.Project__r.Project_Group__c);
                }
            }
            return [select id, name, Care_Product__c, Care_Product__r.name from Project_Group__c where id in :notApprovedtreatmentSet];

        }
        return null;
    }

        @AuraEnabled
        public static List<Institution_Treatment_Indication__c> getProductDetails(Id productId, Id hospitalId){
            Set<Id> ids = new Set<Id>();
            string country;
        for(Institution_Treatment__c instituteTreatment : [SELECT Id, Product_Name__c, Country__c from Institution_Treatment__c Where Institution__c =:hospitalId]){
            ids.add(instituteTreatment.Id);
            country = instituteTreatment.Country__c;
        }

        List<Institution_Treatment_Indication__c> instituteTreatmentList = [select id, Institution_Treatment__r.Product_Name__c,Institution_Treatment__r.Treatment__r.Id,  Institution_Treatment__r.Treatment_Name__c, Institution_Treatment__r.Country__c, Indication__r.Indication_Name__c from Institution_Treatment_Indication__c where Institution_Treatment__r.Country__c =: country AND Institution_Treatment__r.Id !=: ids];

        return instituteTreatmentList;

        }
       @AuraEnabled
        public static List<Treatment_Access_Request__c> treatmentRequestAccessdata(List<Id> treatementIdData){

            List<Treatment_Access_Request__c> treatmentAcclist = new List<Treatment_Access_Request__c>();
            treatmentAcclist= [select id,Treatment_Request__c  from Treatment_Access_Request__c where Project_Group__r.Id =:treatementIdData];
       return treatmentAcclist;
        }
        @AuraEnabled
        public static List<Treatment_Access_Request__c> treatmentRequestAccess(Id treatmentId, Id hospitalId){
            system.debug('TreatmentLookup treatmentId === ' + treatmentId + 'hospitalId ===' + hospitalId);
            List<Treatment_Access_Request__c> treatmentAccessList = new List<Treatment_Access_Request__c>();
            if(treatmentId != null && hospitalId!= null){
                Account acc = [SELECT Id, name from Account where Id =: hospitalId];
                Project_Group__c pGroup = [SELECT Id, name from Project_Group__c where Id =: treatmentId];
                Treatment_Access_Request__c treatmentAccess = new Treatment_Access_Request__c();
                treatmentAccess.Which_Institution__c = acc.Id;
                treatmentAccess.Project_Group__c = pGroup.Id;
                treatmentAccess.Treatment_Request__c= true;
                treatmentAccessList.add(treatmentAccess);
            }
            if(!treatmentAccessList.isEmpty()){
                system.debug('Productdetail treatmentRequestAccess Method'+treatmentAccessList);
                insert treatmentAccessList;
            }
             return treatmentAccessList;
        }

        @AuraEnabled
        public static List<ProductTreatmentWrapper> getProductTreatmentDetails(String productId, String hospitalId){
            system.debug(productId);
            system.debug(hospitalId);
            system.debug('Productdetail getProductTreatmentDetails Method');
            try {
                String countryName = [select Id, Institution_Country__c from account where Id = :hospitalId].Institution_Country__c;
                system.debug('country-->'+countryName);
                List<Institution_Treatment__c> instituteTreatments = [select id,Treatment__c from Institution_Treatment__c where Institution__c  = :hospitalId];
                Set<String> notEligibleTreatments = new Set<String>();
                for(Institution_Treatment__c it: instituteTreatments){
                    notEligibleTreatments.add(it.Treatment__c);
                }
                List<Project_Country__c> projectCountries = [select Id, Project__r.Project_Group__r.name,Project__r.Project_Group__c,Project__r.Project_Group__r.Care_Product__c,Project__r.Project_Status__c from Project_Country__c where Country__c = :countryName and Project__r.Project_Group__r.Care_Product__c = :productId and Project__r.Project_Status__c = 'Live' and Project__r.Project_Group__c not in :notEligibleTreatments];
                Set<String> projectCountryIds = new Set<String>();
                //
                set<string> projectCountrytreatmentIds = new set<string>();
                for(Project_Country__c pc: projectCountries){
                    projectCountryIds.add(pc.Id);
                    //
                    projectCountrytreatmentIds.add(pc.Project__r.Project_Group__c);
                }
                system.debug('inside 288-->'+projectCountries);
                List<Project_Country_Indication__c> pcIndications = [select Id, Name,Indication__c, Indication__r.Indication_Name__c,Project_Country__c,Project_Country__r.Project__r.Project_Group__c  from Project_Country_Indication__c where Project_Country__c in :projectCountryIds];
                List<Project_Country_Eligibility__c> projectCountryEligibilities = [select Id, Name,Eligibility_Type__c, Question__c,Project_Country__c, Project_Country__r.Project__r.Project_Group__c  from Project_Country_Eligibility__c where Project_Country__c in :projectCountryIds and Project_Country__r.ShowEligibilityCriteriaInTA__c = true];
                Set<String> pcIndicationIds = new Set<String>();
                Set<String> indicationIds = new Set<String>();
                for(Project_Country_Indication__c pci: pcIndications){
                    pcIndicationIds.add(pci.Id);
                    indicationIds.add(pci.Indication__c);
                }
                List<Project_Country_Indication_Dosing__c> dosingList = [select Id,Project_Country_Indication__c,Strength__c, Default_Quantity__c from Project_Country_Indication_Dosing__c where Project_Country_Indication__c in :pcIndicationIds];

                Map<String, List<ProductTreatmentWrapper.DosingDetails>> indicationAndDosingDetailsMap = new Map<String, List<ProductTreatmentWrapper.DosingDetails>>();
                // for(Dosing_Detail__c dd: dosingList){
                //     ProductTreatmentWrapper.DosingDetails dosingDetails = new ProductTreatmentWrapper.DosingDetails();
                //     dosingDetails.id = dd.Id;
                //     dosingDetails.productInformation = dd.Product_Information__c;
                //     dosingDetails.strength = dd.Strength__c;
                //     dosingDetails.defaultQuantity = dd.Default_Quantity__c;
                //     List<ProductTreatmentWrapper.DosingDetails> dosingListWrapper = null;
                //     if(indicationAndDosingDetailsMap.containskey(dd.Indication__c)){
                //         dosingListWrapper = indicationAndDosingDetailsMap.get(dd.Indication__c);
                //     } else {
                //         dosingListWrapper = new List<ProductTreatmentWrapper.DosingDetails>();
                //         indicationAndDosingDetailsMap.put(dd.Indication__c,dosingListWrapper);
                //     }
                //     dosingListWrapper.add(dosingDetails);
                // }

                for(Project_Country_Indication_Dosing__c dd: dosingList){
                    ProductTreatmentWrapper.DosingDetails dosingDetails = new ProductTreatmentWrapper.DosingDetails();
                    dosingDetails.id = dd.Id;
                    //dosingDetails.productInformation = dd.Product_Information__c;
                    dosingDetails.strength = dd.Strength__c;
                    dosingDetails.defaultQuantity = dd.Default_Quantity__c;
                    List<ProductTreatmentWrapper.DosingDetails> dosingListWrapper = null;
                    if(indicationAndDosingDetailsMap.containskey(dd.Project_Country_Indication__c)){
                        dosingListWrapper = indicationAndDosingDetailsMap.get(dd.Project_Country_Indication__c);
                    } else {
                        dosingListWrapper = new List<ProductTreatmentWrapper.DosingDetails>();
                        indicationAndDosingDetailsMap.put(dd.Project_Country_Indication__c,dosingListWrapper);
                    }
                    dosingListWrapper.add(dosingDetails);
                }
                system.debug('????');
                system.debug('inside 317-->'+indicationAndDosingDetailsMap);
                Map<String,List<ProductTreatmentWrapper.Criteria>> projectCountryAndInclusionMap = new Map<String,List<ProductTreatmentWrapper.Criteria>>();
                Map<String,List<ProductTreatmentWrapper.Criteria>> projectCountryAndExclusionMap = new Map<String,List<ProductTreatmentWrapper.Criteria>>();
                for(Project_Country_Eligibility__c pce :projectCountryEligibilities){
                    ProductTreatmentWrapper.Criteria criteria = new ProductTreatmentWrapper.Criteria();
                    criteria.id = pce.Id;
                    criteria.question = pce.Question__c;
                    List<ProductTreatmentWrapper.Criteria> criterias = null;
                    if(pce.Eligibility_Type__c == 'Inclusion Criteria'){
                        if(projectCountryAndInclusionMap.containskey(pce.Project_Country__c)){
                            criterias = projectCountryAndInclusionMap.get(pce.Project_Country__c);
                        } else {
                            criterias = new List<ProductTreatmentWrapper.Criteria>();
                            projectCountryAndInclusionMap.put(pce.Project_Country__c,criterias);
                        }
                    } else if(pce.Eligibility_Type__c == 'Exclusion Criteria'){
                        if(projectCountryAndExclusionMap.containskey(pce.Project_Country__c)){
                            criterias = projectCountryAndExclusionMap.get(pce.Project_Country__c);
                        } else {
                            criterias = new List<ProductTreatmentWrapper.Criteria>();
                            projectCountryAndExclusionMap.put(pce.Project_Country__c,criterias);
                        }
                    }
                    criterias.add(criteria);
                }
                Map<String, List<ProductTreatmentWrapper.Indications>> treatmentAndDosingDetailsMap = new Map<String, List<ProductTreatmentWrapper.Indications>>();
                for(Project_Country_Indication__c pci: pcIndications){
                    ProductTreatmentWrapper.Indications ptwIndication = new ProductTreatmentWrapper.Indications();
                    ptwIndication.pcid = pci.Project_Country__c;
                    ptwIndication.name = pci.Indication__r.Indication_Name__c;
                    ptwIndication.id = pci.Id;
                    ptwIndication.dosingDetails = indicationAndDosingDetailsMap.get(pci.Id);
                    ptwIndication.inclusionCriteria = projectCountryAndInclusionMap.get(pci.Project_Country__c);
                    ptwIndication.exclusionCriteria = projectCountryAndExclusionMap.get(pci.Project_Country__c);
                    List<ProductTreatmentWrapper.Indications> wrapperIndications = null;
                    if(treatmentAndDosingDetailsMap.containskey(pci.Project_Country__r.Project__r.Project_Group__c)){
                        wrapperIndications = treatmentAndDosingDetailsMap.get(pci.Project_Country__r.Project__r.Project_Group__c);
                    } else {
                        wrapperIndications = new List<ProductTreatmentWrapper.Indications>();
                        treatmentAndDosingDetailsMap.put(pci.Project_Country__r.Project__r.Project_Group__c,wrapperIndications);
                    }
                    wrapperIndications.add(ptwIndication);
                }
                ////

             List<Treatment_Access_Request__c> tarList = new List<Treatment_Access_Request__c>();
             map<Id,Boolean> treatmentStatusMap = new  map<Id,Boolean>();
             tarList = [SELECT id,Treatment_Request__c,Project_Group__r.Id,Status__c  FROM Treatment_Access_Request__c WHERE Project_Group__r.Id in: projectCountrytreatmentIds and Status__c='Pending By Bionical' and Which_Institution__c = :hospitalId];

                for(Treatment_Access_Request__c tar : tarList)
                {
                    treatmentStatusMap.put(tar.Project_Group__r.Id,true);
                }
                System.debug('treatmentStatusMap : ' + treatmentStatusMap);
                /////
                List<ProductTreatmentWrapper> resultList = new List<ProductTreatmentWrapper>();
                Set<String> uniqueTreatmentIds = new Set<String>();
                for(Project_Country__c pc:projectCountries){
                    system.debug('inside 363-->');
                    if(!uniqueTreatmentIds.contains(pc.Project__r.Project_Group__c)){
                        system.debug('inside 365-->'+uniqueTreatmentIds);
                        uniqueTreatmentIds.add(pc.Project__r.Project_Group__c);
                        ProductTreatmentWrapper ptw = new ProductTreatmentWrapper();
                        ptw.treatmentName = pc.Project__r.Project_Group__r.Name;
                        ptw.treatmentId = pc.Project__r.Project_Group__c;
                        ptw.indications = treatmentAndDosingDetailsMap.get(pc.Project__r.Project_Group__c);
                        //
                        Boolean status = treatmentStatusMap.get(pc.Project__r.Project_Group__c);
                        system.debug('Productdetail getProductTreatmentDetails status Method '+status);
                        if(status == null)
                            status = false;
                        system.debug('Productdetail null getProductTreatmentDetails status Method '+status);

                        ptw.treatmentStatus = status;
                        resultList.add(ptw);
                    }
                }
                system.debug('inside result-->'+resultList);
                return resultList;
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }



        public class WrapperTreatmentLookup
        {
            @AuraEnabled
            public Boolean isProductExists {get;set;}
            @AuraEnabled
            public Care_Products__c careProducts{get;set;}
            @AuraEnabled
            public Project_Group__c projectGroup{get;set;}
            @AuraEnabled
            public Project__c project {get;set;}
            @AuraEnabled
           public Project_Country_Indication__c indication{get;set;}
            @AuraEnabled
            public Project_Country_Indication__c countryIndication{get;set;}

            @AuraEnabled
            public List<SObject> projectCountryList{get;set;}


        }



    }