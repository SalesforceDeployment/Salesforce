public class ProjectCountryEligibilityHandler {
    public static void restrictDelection(List<Project_Country_Eligibility__c> projCountryEligibilityListObj, Map<Id, Project_Country_Eligibility__c> projCountryEligibilityListObjRel){
        String strProjectStatus ='';
        for(Project_Country_Eligibility__c projCountryEligibility:projCountryEligibilityListObj){
            strProjectStatus = projCountryEligibility.Project_Country__r.Project__r.Project_Status__c;
            if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                projCountryEligibility.addError('You can not delete Project Country Eligibility record, if Project Status is ' + strProjectStatus + '.');
            }
        }
    }
    
    
    public static void restrictUpdation(List<Project_Country_Eligibility__c> projCountryEligibilityList){
        String strProjectStatus ='';
        for(Project_Country_Eligibility__c projCountryEligibility:projCountryEligibilityList){
            strProjectStatus = projCountryEligibility.Project_Country__r.Project__r.Project_Status__c;
            if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                projCountryEligibility.addError('You can not update Project Country Eligibility record, if Project Status is ' + strProjectStatus + '.');
            }
        }
    }
    
    public static void restrictInsertion(List<Project_Country_Eligibility__c> projCountryEligibilityList){
        String strProjectStatus ='';
        for(Project_Country_Eligibility__c projCountryEligibility:projCountryEligibilityList){
            strProjectStatus = projCountryEligibility.Project_Country__r.Project__r.Project_Status__c;
            if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                
                projCountryEligibility.addError('You can not add Project Country Eligibility record, if Project Status is ' + strProjectStatus + '.');
            }
        }
        
    }
}