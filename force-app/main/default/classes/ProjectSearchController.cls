public without sharing class ProjectSearchController {
    
    @AuraEnabled
    public static List<Project__c> searchProjects(String searchTerm,Id accconId) {
        if (String.isBlank(searchTerm)) {
            return [SELECT Id,Project_Group__r.Name, Name,Organisation__r.Name FROM Project__c WHERE Project_Status__c='Live' AND Organisation__c=:accconId];
        } else {
            searchTerm = '%' + searchTerm + '%';
            return [SELECT Id,Project_Group__r.Name, Name,Organisation__r.Name FROM Project__c WHERE Project_Status__c='Live' AND Organisation__c=:accconId AND (Name LIKE :searchTerm OR Project_Group__r.Name LIKE :searchTerm OR Project_Code__c LIKE :searchTerm)];
        }
    }
    @AuraEnabled
    public static List<ProjectWrapper> searchProject(String searchTerm,Id accconId) {
        Map<String, ProjectWrapper> projectGroups = new Map<String, ProjectWrapper>();
        
        if (String.isBlank(searchTerm)) {
            for (Project__c project : [SELECT Id, Name, Project_Status__c, Organisation__c, Project_Group__r.Name,Organisation__r.Name FROM Project__c WHERE Project_Status__c='Live' AND Organisation__c=:accconId]) {
                if (!projectGroups.containsKey(project.Project_Group__r.Name)) {
                    projectGroups.put(project.Project_Group__r.Name, new ProjectWrapper(project.Project_Group__r.Name));
                }
                projectGroups.get(project.Project_Group__r.Name).addProject(project);
            }
        } else {
            searchTerm = '%' + searchTerm + '%';
            for (Project__c project : [SELECT Id, Name, Project_Status__c, Organisation__c, Project_Group__r.Name,Organisation__r.Name FROM Project__c WHERE Project_Status__c='Live' AND Organisation__c=:accconId AND (Name LIKE :searchTerm OR Project_Group__r.Name LIKE :searchTerm OR Project_Code__c LIKE :searchTerm)]) {
                if (!projectGroups.containsKey(project.Project_Group__r.Name)) {
                    projectGroups.put(project.Project_Group__r.Name, new ProjectWrapper(project.Project_Group__r.Name));
                }
                projectGroups.get(project.Project_Group__r.Name).addProject(project);
            }
        }
        
        return new List<ProjectWrapper>(projectGroups.values());
    }
    @AuraEnabled
    public static List<Project_Group__c>  fetchPGDataName(String progrName){
        try {
            return [SELECT Id,Name, (SELECT Id,Name,Project_Status__c,Project_Date__c FROM Projects__r WHERE Project_Status__c='Live') FROM Project_Group__c WHERE Name LIKE : progrName];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static ProjectDataWrapper  fetchProjData(Id ProjId){
        try {
            Project__c projList =[SELECT Id,Name,Project_Group__r.Name,Organisation__r.Name,Project_Status__c, (Select Id,Name,Organization__c from Project_Organization_Members__r), (Select Id,Name,Indication_Name__c from Project_Indications__r) FROM Project__c WHERE Id=:ProjId];
            List<Contact> orgContact=[SELECT Id,Name from Contact where Id IN (SELECT Organization_Contact__c FROM Project_Organization_Member__c  WHERE Project__c=:projList.Id)]; 
            return new ProjectDataWrapper(projList,orgContact);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public class ProjectDataWrapper{
        @AuraEnabled public Project__c projList {get;set;}
        @AuraEnabled public  List<Contact> orgContact {get;set;}
        public ProjectDataWrapper(Project__c proj, List<Contact> orgs) {
            this.projList=proj;
            this.orgContact=orgs;
        }        
    }
    @AuraEnabled
    public static List<Project_Country__c> getprojectscountryData(Id selectedId) {
        List<Project_Country__c> projcountryList = new List<Project_Country__c>();
        for(Project_Country__c procountry : [SELECT Id,Name,Country__c,Project__c from Project_Country__c where Project__c=:selectedId ]) {
            projcountryList.add(procountry);  
        }
        return projcountryList;
    }
}