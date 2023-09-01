public class ProjectSupportingInfoReqTriggerHandler {
    public static void restrictDelection(List<Project_Supporting_Information__c> projSIDListObj, Map<Id, Project_Supporting_Information__c> projSIDObjRel){
       
            String strProjectStatus ='';
            for(Project_Supporting_Information__c projSID:projSIDListObj){
               
                strProjectStatus = projSID.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    
                    projSID.addError('You can not delete Project Supporting Information record, if Project Status is ' + strProjectStatus + '.');
                }
            }
        
    }
    
    public static void restrictUpdation(List<Project_Supporting_Information__c> projSIDList){
       
            String strProjectStatus ='';
            
            for(Project_Supporting_Information__c projSID:projSIDList){
                strProjectStatus = projSID.Project_Status__c;
                
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                
                    projSID.addError('You can not update Project Supporting Information record, if Project Status is ' + strProjectStatus + '.');
                }
            }
       
    }
    
    public static void restrictInsertion(List<Project_Supporting_Information__c> projSIDListObj){
       
            String strProjectStatus ='';
            for(Project_Supporting_Information__c projSID:projSIDListObj){
                strProjectStatus = projSID.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    
                    projSID.addError('You can not add Project Supporting Information record, if Project Status is ' + strProjectStatus + '.');
                }
            }
        
    }
}