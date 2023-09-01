public class projectTriggerHandler {
    
    public static void restrictDelection(List<project__c> projectListObj, Map<Id, project__c> projectObjRel){
        
        String strProjectStatus ='';
        for(project__c proj:projectListObj){
            strProjectStatus = proj.Project_Status__c;
            if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                proj.addError('You can not delete Project if its Status is ' + strProjectStatus + '.');
            }
        }
        
    }
    
    public static void restrictUpdation(List<project__c> projectList, Map<Id,project__c> projectOldMap){
        
        String strProjectStatus ='';
        // String UserId = UserInfo.getUserId();
        //List<User> user =[SELECT Name, UserRole.Name, IsActive, Id, Profile.Name FROM User WHERE  IsActive = true And Id =: UserId Limit 1];
        //String UserRole ;
        //if(user.size()>0){
        //	UserRole = user[0].UserRole.Name;
        //}
        for(project__c proj:projectList) {
            project__c oldProject = projectOldMap.get(proj.Id);
            //live
            system.debug('old strProjectStatus ' + oldProject.Project_Status__c);
            strProjectStatus = proj.Project_Status__c;
            system.debug('new strProjectStatus ' + strProjectStatus);
            if(strProjectStatus!='Draft in Review' && proj.BypassValidation__c == true){
                proj.BypassValidation__c = false;
            } else if(oldProject.Project_Status__c =='Draft Creation in Progress' && strProjectStatus =='Draft in Review'){
                //proj.Project_Status__c = 'Draft Creation in Progress';
            } else if(oldProject.Project_Status__c =='Live' && strProjectStatus =='Closed'){
                //proj.Project_Status__c = 'Draft Creation in Progress';
            } else if(oldProject.Project_Status__c =='Draft Project Approved' && strProjectStatus =='Live'){
                //proj.Project_Status__c = 'Draft Creation in Progress';
            } else if(oldProject.Project_Status__c =='Draft in Review' && strProjectStatus =='Draft Project Approved'){
                // proj.addError('You can not update Project if its Status is ' + strProjectStatus + '.');
            } else if(strProjectStatus =='Live'|| (strProjectStatus =='Draft Project Approved' && oldProject.Project_Status__c!='Draft Project Approved' && proj.BypassValidation__c == false) 
                      || strProjectStatus =='Closed' 
                      || (strProjectStatus =='Draft in Review'  && oldProject.Project_Status__c!='Draft Project Declined' && proj.Sponsor__c != null && oldProject.Sponsor__c == proj.Sponsor__c && proj.BypassValidation__c == false && oldProject.BypassValidation__c==proj.BypassValidation__c)
                      ||(oldProject.Project_Status__c =='Draft Project Approved' && strProjectStatus =='Draft Project Approved')                    
                     ) {
                         proj.addError('You can not update Project if its Status is ' + strProjectStatus + '.');
                     }
            /*  else if((strProjectStatus =='Draft Creation in Progress' && proj.Recalled__c == true && UserRole=='Project Manager' )){
proj.addError('You can not update Project if its recalled'); 
}*/
            //commented because it's failing UAT-136
            /*else if(oldProject.Project_Status__c =='Draft Project Declined'){
proj.Project_Status__c = 'Draft Creation in Progress';
}*/
            
        }
    }
    
}