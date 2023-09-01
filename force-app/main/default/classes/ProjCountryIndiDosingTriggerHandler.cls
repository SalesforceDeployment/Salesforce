public class ProjCountryIndiDosingTriggerHandler {
    
    public static void restrict(List<Project_Country_Indication_Dosing__c> projCountryIndiDosingList, String operation){
        	List<String> projectCountryIndicationIds = new List<String>();
            for(Project_Country_Indication_Dosing__c pcid: projCountryIndiDosingList){
                projectCountryIndicationIds.add(pcid.Project_Country_Indication__c);
            }
        	Map<Id, Project_Country_Indication__c> projectCountriesIndiacationMap = new Map<Id,Project_Country_Indication__c>([select Id, Project_Country__r.Project__r.Project_Status__c from Project_Country_Indication__c where id in :projectCountryIndicationIds]);
        	
            for(Project_Country_Indication_Dosing__c projCountryIndication:projCountryIndiDosingList){
				Project_Country_Indication__c pc = projectCountriesIndiacationMap.get(projCountryIndication.Project_Country_Indication__c);
                String strProjectStatus = pc.Project_Country__r.Project__r.Project_Status__c;
                if(strProjectStatus =='Live' || strProjectStatus =='Draft in Review' || strProjectStatus =='Draft Project Approved' || strProjectStatus =='Closed'){
                    projCountryIndication.addError('You can not '+operation+' Project Country Indication record, if Project Status is ' + strProjectStatus + '.');
                }
            }
        
    }
}