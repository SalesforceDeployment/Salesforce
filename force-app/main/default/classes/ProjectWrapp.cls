public class ProjectWrapp {
    @AuraEnabled public String projectGroupName {get; set;}
    @AuraEnabled public List<ProjectDetails> projectDetails {get; set;}
    
    public ProjectWrapp(String name) {
        projectGroupName = name;
        projectDetails = new List<ProjectDetails>();
    }
    
    public void addProject(Project__c project) {
        projectDetails.add(new ProjectDetails(project));
    }
    
    public class ProjectDetails {
        @AuraEnabled public String projectName {get; set;}
        @AuraEnabled public String projectStatus {get; set;}
        @AuraEnabled public String organisationName {get; set;}
        
        public ProjectDetails(Project__c project) {
            projectName = project.Name;
            projectStatus = project.Project_Status__c;
            organisationName = project.Organisation__r.Name;
        }
    }
}