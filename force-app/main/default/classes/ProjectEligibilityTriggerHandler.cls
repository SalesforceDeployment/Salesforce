public class ProjectEligibilityTriggerHandler {
    public static void restrictDelection(List<Project_Eligibility__c> projEligibilityListObj, Map<Id, Project_Eligibility__c> projEligibilityObjRel){
        String strProjectStatus ='';
        for(Project_Eligibility__c projEligibility:projEligibilityListObj){
            strProjectStatus = projEligibility.Project_Status__c;
            if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                projEligibility.addError('You can not delete Project Eligibility record, if Project Status is ' + strProjectStatus + '.');
            }
        }
        
    }
    
    public static void restrictUpdation(List<Project_Eligibility__c> projEligibilityList){
        
        String strProjectStatus ='';
        for(Project_Eligibility__c projEligibility:projEligibilityList){
            strProjectStatus = projEligibility.Project_Status__c;
            if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                projEligibility.addError('You can not update Project Eligibility record, if Project Status is ' + strProjectStatus + '.');
            }
        }
        
    }
    
    public static void restrictInsertion(List<Project_Eligibility__c> projEligibilityListObj){
        
        String strProjectStatus ='';
        for(Project_Eligibility__c projEligibility:projEligibilityListObj){
            strProjectStatus = projEligibility.Project_Status__c;
            if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                projEligibility.addError('You can not add Project Eligibility record, if Project Status is ' + strProjectStatus + '.');
            }
        }
        
    }
}