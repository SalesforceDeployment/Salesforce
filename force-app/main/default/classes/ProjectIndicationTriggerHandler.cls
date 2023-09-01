public class ProjectIndicationTriggerHandler {
    public static void restrictDelection(List<Project_Indication__c> projIndListObj, Map<Id, Project_Indication__c> projIndObjRel){
       
            String strProjectStatus ='';
            for(Project_Indication__c projInd:projIndListObj){
                
                String projID = projInd.Project__c;
                strProjectStatus = projInd.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    projInd.addError('You can not delete Project Indication record, if Project Status is ' + strProjectStatus + '.');
                }
            }
        
    }
    
    public static void restrictUpdation(List<Project_Indication__c> projIndList){
        
            String strProjectStatus ='';
            
            for(Project_Indication__c projInd:projIndList){
               	strProjectStatus = projInd.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    projInd.addError('You can not update Project Indication record, if Project Status is ' + strProjectStatus + '.');
                }
            }
    }
    
    public static void restrictInsertion(List<Project_Indication__c> projIndListObj){
       
            String strProjectStatus ='';
            for(Project_Indication__c projInd:projIndListObj){
                strProjectStatus = projInd.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    projInd.addError('You can not add Project Indication record, if Project Status is ' + strProjectStatus + '.');
                }
            }
    }
}