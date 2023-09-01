public class ProjectWrapper {
  /* <template for:each={projectname} for:item="proj" index="index">
    <tr class="slds-hint-parent" key={proj.projectGroupName}>
        <td rowspan={proj.rowSpan}>
            <div class="slds-truncate">
                <a href="*" data-id={proj.projectGroupName} onclick={handlePGData}>{proj.projectGroupName}</a>
            </div>
        </td>
        <template for:each={proj.projectDetails} for:item="project">
            <tr key={project.projectName}>
                <template if:true={index === 0}>
                    <td rowspan={proj.rowSpan}>
                        <div class="slds-truncate">
                            {proj.projectGroupName}
                        </div>
                    </td>
                </template>
                <td>
                    <a href="*" data-id={project.projectId} onclick={handleProjData}>{project.projectName}</a>
                </td>
                <td>
                    <div class="slds-truncate">
                        {project.organisationName}
                    </div>
                </td>
            </tr>
        </template>
    </tr>
</template>
*/
    @AuraEnabled public String projectGroupName {get; set;}
 
    @AuraEnabled public List<ProjectDetails> projectDetails {get; set;}
    
    public ProjectWrapper(String name) {
        projectGroupName = name;
        projectDetails = new List<ProjectDetails>();
    }
   
    
    public void addProject(Project__c project) {
        projectDetails.add(new ProjectDetails(project));
    }
    
    public class ProjectDetails {
        @AuraEnabled public String projectName {get; set;}
        @AuraEnabled public String projectId {get; set;}
         @AuraEnabled public String projectGroupId {get; set;} 
        @AuraEnabled public String projectStatus {get; set;}
        @AuraEnabled public String organisationName {get; set;}
        
        public ProjectDetails(Project__c project) {
            projectName = project.Name;
            projectId=project.Id;
            projectGroupId=project.Project_Group__r.Id;
            projectStatus = project.Project_Status__c; 
            organisationName = project.Organisation__r.Name;
        }
    }
}