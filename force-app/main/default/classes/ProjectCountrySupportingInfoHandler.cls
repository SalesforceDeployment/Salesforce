public class ProjectCountrySupportingInfoHandler {
    public static void restrictDelection(List<Project_Country_Supporting_Information__c> projCountrySupportingInfoListObj, Map<Id, Project_Country_Supporting_Information__c> projCountrySupportingInfoListObjRel){
            String strProjectStatus ='';
            for(Project_Country_Supporting_Information__c projCountrySupportingInfo:projCountrySupportingInfoListObj){
                strProjectStatus = projCountrySupportingInfo.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    
                    projCountrySupportingInfo.addError('You can not delete Project Country Supporting Information record, if Project Status is ' + strProjectStatus + '.');
                }
                
            }
    }
    
    public static void restrictUpdation(List<Project_Country_Supporting_Information__c> projCountrySupportingInfoList){
            String strProjectStatus ='';
            for(Project_Country_Supporting_Information__c projCountrySupportingInfo:projCountrySupportingInfoList){
                strProjectStatus = projCountrySupportingInfo.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    projCountrySupportingInfo.addError('You can not update Project Country Supporting Information record, if Project Status is ' + strProjectStatus + '.');
                }
            }
    }
    
    public static void restrictInsertion(List<Project_Country_Supporting_Information__c> projCountrySupportingInfoList){
            String strProjectStatus ='';
            for(Project_Country_Supporting_Information__c projCountrySupportingInfo:projCountrySupportingInfoList){
                strProjectStatus = projCountrySupportingInfo.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    
                    projCountrySupportingInfo.addError('You can not add Project Country Supporting Information record, if Project Status is ' + strProjectStatus + '.');
                }
            }
        
    }
}