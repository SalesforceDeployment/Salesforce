@isTest
private class ProjectHandlerTest {
    @isTest
    static void testCloneProject() {
        // Create test data
        Care_Products__c product = new Care_Products__c();
        product.Name = 'test1';        
        insert product;
        
        Project_Group__c projGroup = new Project_Group__c();
        projGroup.Name = 'Project Group1 ';
        projGroup.Care_Product__c = product.Id;
        projGroup.Status__c = 'Live';
        insert projGroup;
        
        project__c originalProject = new project__c();
		originalProject.Name = 'project1 ';
        originalProject.Project_Code__c = '1236';
        originalProject.No_of_weeks_treatment__c   = 3 ;
        originalProject.Project_Status__c = 'Draft Creation in Progress';
        originalProject.Project_Group__c = projGroup.Id;
    
        insert originalProject;
        List<project__c> proj = new List<project__c>();
        proj.add(originalProject);
        List<Indication__c> ind = UtilData.createIndication(1);
        insert ind;
        List<Project_Indication__c> pi = UtilData.createProjectIndication(proj,ind,1);
        insert pi;
        List<Project_Organization_Member__c> pom = UtilData.createProjectOrganizationMember(proj);
        insert pom;
        List<Project_Regulatory_Consent__c> prc = UtilData.createProjectRegulatorConsent(proj);
        insert prc;
        List<Project_Patient_Parameter__c> ppp = UtilData.createProjectPatientParameter(proj);
        insert ppp;
        List<Project_Country__c> pc = UtilData.createProjectCountry(proj);
        insert pc;
        List<Project_Eligibility__c> pe = UtilData.createProjectEligibility(proj);
        insert pe;
        List<Project_Supporting_Information__c> psi = UtilData.createProjectSuportingInformation(proj);
        insert psi;
        List<Project_Country_Supporting_Information__c> pcsi = UtilData.createProjSuppInfo(pc);
        insert pcsi;
        List<Project_Country_Eligibility__c> pce = UtilData.createProjectCountryEligibilities(pc);
        insert pce;
        ProjectHandler.InputVariable input = new ProjectHandler.InputVariable();
        input.projectId = originalProject.Id;
        List<ProjectHandler.InputVariable> inputs = new List<ProjectHandler.InputVariable>{input};
        
        // Call the cloneProject method
        Test.startTest();
        ProjectHandler.cloneProject(inputs);
        Test.stopTest();
                       
        // Verify the cloned project and its child objects
        Project__c clonedProject = [SELECT Id, Name, Project_Status__c FROM Project__c WHERE Parent_Project__c = :originalProject.Id];
        System.assertEquals('Draft Creation in Progress', clonedProject.Project_Status__c);
        
        List<Project_Country__c> clonedProjectCountries = [SELECT Id FROM Project_Country__c WHERE Project__c = :clonedProject.Id];
       // System.assertNotEquals(0, clonedProjectCountries.size());
        
        // Verify other child objects as needed
        
        // Clean up test data
       // delete clonedProjectCountries;
        //delete clonedProject;
    }
}