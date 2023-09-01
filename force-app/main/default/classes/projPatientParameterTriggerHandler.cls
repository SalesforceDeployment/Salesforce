public class projPatientParameterTriggerHandler {
    public static void restrictDelection(List<Project_Patient_Parameter__c> projPPListObj, Map<Id, Project_Patient_Parameter__c> projPPObjRel){
        
            String strProjectStatus ='';
            for(Project_Patient_Parameter__c projPP:projPPListObj){
                strProjectStatus = projPP.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    
                    projPP.addError('You can not delete Project Patient Parameter record, if Project Status is ' + strProjectStatus + '.');
                }
            }
        
    }
    
    public static void restrictUpdation(List<Project_Patient_Parameter__c> projPPList){
       
            String strProjectStatus ='';
            for(Project_Patient_Parameter__c projPP:projPPList){
                strProjectStatus = projPP.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    
                    projPP.addError('You can not update Project Patient Parameter record, if Project Status is ' + strProjectStatus + '.');
                }
            }
        
    }
    
    public static void restrictInsertion(List<Project_Patient_Parameter__c> projPPListObj){
        
            String strProjectStatus ='';
            for(Project_Patient_Parameter__c projPP:projPPListObj){
                strProjectStatus = projPP.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    
                    projPP.addError('You can not add Project Patient Parameter record, if Project Status is ' + strProjectStatus + '.');
                }
            }
       
    }
}