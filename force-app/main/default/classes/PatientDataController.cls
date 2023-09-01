public without sharing class PatientDataController {
    
    
    @AuraEnabled
    public static List<Project_Country_Regulatory_Consent__c>  getProjectCountryRegulatoryData(Id pcIndicationId) 
    {
        try {
            Project_Country_Indication__c pcI;
            List<Project_Country_Regulatory_Consent__c> pcrc = new List<Project_Country_Regulatory_Consent__c>();
            if(pcIndicationId!=null)
            {
                pcI = [SELECT Id, Name, Project_Country__r.Id, Project_Country__r.Name FROM Project_Country_Indication__c WHERE Id =:pcIndicationId ];
                if(pcI != null)
                {
                    pcrc = [SELECT Id, Name,Consent_Title__c, Consent_Description__c,Sequence_Order__c FROM Project_Country_Regulatory_Consent__c WHERE Project_Country__r.Id =: pcI.Project_Country__r.Id];
                } 
            }
            return pcrc;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());   
        }
        
        
    }
    
    @AuraEnabled
    public static Project_Country_Indication__c getAdditionalAndAdverseInfo(Id pcIndicationId) 
    {
        try {
            Project_Country_Indication__c pcIAddAdv = new Project_Country_Indication__c();
            if(pcIndicationId!=null)
            {
                pcIAddAdv = [SELECT Id, Name, Project_Country__r.Id, Project_Country__r.Name,Project_Country__r.Allow_Initial_Patient_Requests__c,Project_Country__r.Allow_Repeat_Patient_Requests__c,
                             Project_Country__r.Adverse_Event_Email__c, Project_Country__r.Adverse_Event_Fax__c, Project_Country__r.Adverse_Event_Telephone__c,Project_Country__r.Patient_BSA__c,
                             Project_Country__r.Required_Dose_Field_enabled__c, Project_Country__r.Additional_Product_Information__c, Project_Country__r.Project__r.Reconciliation_Required__c,
                             Indication__r.Id, Indication__r.Indication_Name__c,Project_Country__r.Approval_Needed__c,Project_Country__r.Approval_Level__c,
                             Project_Country__r.First_Order_Only__c, Project_Country__r.Project__r.Project_Status__c FROM Project_Country_Indication__c where Id=: pcIndicationId];
            }
            return pcIAddAdv;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());   
            
        }
        
        
    }
    @AuraEnabled
    public static DosingDetailsWrapper getDosingDetailsforPatient(Id pCIndicationId, Id patientRequestId) {
        try {
            DosingDetailsWrapper dosingWraper =  new DosingDetailsWrapper();
            if(patientRequestId != null && pCIndicationId != null)
            {
                List<Patient_Dosage_Request__c> pdRequestList = new List<Patient_Dosage_Request__c>();
                pdRequestList = [SELECT Id, Strength__c, Reassigned_Quantity__c, Quantity_Shipped__c, Quantity__c, Dosing_Details__c, Dosing_Details__r.Can_be_overridden_by_HCP__c FROM Patient_Dosage_Request__c WHERE Patient_Access_Request__c =:patientRequestId];
                List<DosingDetailsWrapper.DosingDetails> details = new List<DosingDetailsWrapper.DosingDetails>();
                for(Patient_Dosage_Request__c pdr: pdRequestList){
                    DosingDetailsWrapper.DosingDetails detail = new DosingDetailsWrapper.DosingDetails();
                    detail.Id = pdr.Dosing_Details__c;
                    detail.DefaultQuantity = pdr.Quantity__c != null ? pdr.Quantity__c : 0;
                    detail.reassignedQuantity = pdr.Reassigned_Quantity__c != null ? pdr.Reassigned_Quantity__c : 0;
                    detail.ShippedQuantity = pdr.Quantity_Shipped__c != null ? pdr.Quantity_Shipped__c : 0;
                    detail.Strength = pdr.Strength__c;
                    detail.active =  !pdr.Dosing_Details__r.Can_be_overridden_by_HCP__c;
                    detail.patientDosageRequestId = pdr.Id;
                    details.add(detail);
                }
                dosingWraper.dosingDetails = details;
            }
            if(pCIndicationId != null && dosingWraper.dosingDetails.size() == 0)
            {
                
                List<Project_Country_Indication_Dosing__c> dosingList = new List<Project_Country_Indication_Dosing__c>();
                dosingList = [SELECT Can_be_overridden_by_HCP__c,Default_Quantity__c,Id,Strength__c FROM Project_Country_Indication_Dosing__c WHERE Project_Country_Indication__c =: pCIndicationId];
                List<DosingDetailsWrapper.DosingDetails> details = new List<DosingDetailsWrapper.DosingDetails>();
                for(Project_Country_Indication_Dosing__c dd: dosingList){
                    DosingDetailsWrapper.DosingDetails detail = new DosingDetailsWrapper.DosingDetails();
                    detail.Id = dd.Id;
                    detail.DefaultQuantity = dd.Default_Quantity__c != null ? dd.Default_Quantity__c : 0;
                    detail.Strength = dd.Strength__c;
                    detail.active =  !dd.Can_be_overridden_by_HCP__c;
                    details.add(detail);
                }
                dosingWraper.dosingDetails = details;
            }
            return dosingWraper;
            
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());   
        }   
    }
    
    @AuraEnabled
    public static String getProjectCode(Id pcIndicationId) 
    {
        try {
            String retValue = '';
            Project_Country_Indication__c pcIAddAdv = new Project_Country_Indication__c();
            if(String.isNotBlank(pcIndicationId))
            {
                pcIAddAdv = [SELECT Id, Name, Project_Country__r.Project__r.Project_Code__c FROM Project_Country_Indication__c WHERE Id=: pcIndicationId];
                if(pcIAddAdv != null)
                {
                    if(String.isNotBlank(pcIAddAdv.Project_Country__r.Project__r.Project_Code__c))
                    {
                        retValue = pcIAddAdv.Project_Country__r.Project__r.Project_Code__c;
                    }
                }
            }
            return retValue;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());   
        }
    }
    
}