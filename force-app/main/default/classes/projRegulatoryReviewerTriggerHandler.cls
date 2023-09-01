public class projRegulatoryReviewerTriggerHandler {
	public static void restrict(List<Project_Regulatory_Reviewers__c> projRRList, String operation){
        
        List<String> projectRRIds = new List<String>();
            for(Project_Regulatory_Reviewers__c pcid: projRRList){
                projectRRIds.add(pcid.Project__c);
            }
        	Map<Id, Project__c> projectRRMap = new Map<Id,Project__c>([select Id, Project_Status__c from Project__c where id in :projectRRIds]);
        	
            for(Project_Regulatory_Reviewers__c projCountryIndication:projRRList){
				Project__c p = projectRRMap.get(projCountryIndication.Project__c);
                String strProjectStatus = p.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    projCountryIndication.addError('You can not '+operation+' Project Regulatory Reviewer record, if Project Status is ' + strProjectStatus + '.');
                }
            }
        
    }
}