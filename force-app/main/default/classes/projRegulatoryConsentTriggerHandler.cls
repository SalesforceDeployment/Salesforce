public class projRegulatoryConsentTriggerHandler {
    public static void restrictDelection(List<Project_Regulatory_Consent__c> projRCListObj, Map<Id, Project_Regulatory_Consent__c> projRCObjRel){
        
        String strProjectStatus ='';
        for(Project_Regulatory_Consent__c projRC:projRCListObj){
            strProjectStatus = projRC.Project__r.Project_Status__c;

            if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                
                projRC.addError('You can not delete Project Regulatory Consent record, if Project Status is ' + strProjectStatus + '.');
            }
            
        }
        
    }
    
    public static void restrictUpdation(List<Project_Regulatory_Consent__c> projRCList){
        
        String strProjectStatus ='';
        for(Project_Regulatory_Consent__c projRC:projRCList){
            strProjectStatus = projRC.Project_Status__c;
            if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                projRC.addError('You can not update Project Regulatory Consent record, if Project Status is ' + strProjectStatus + '.');
            }
        }
        
    }
    
    public static void restrictInsertion(List<Project_Regulatory_Consent__c> projRCListObj){
        
        String strProjectStatus ='';
        for(Project_Regulatory_Consent__c projRC:projRCListObj){
            strProjectStatus = projRC.Project_Status__c;
            if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){             
                projRC.addError('You can not add Project Regulatory Consent record, if Project Status is ' + strProjectStatus + '.');
            }
        }
        
        
    }
}