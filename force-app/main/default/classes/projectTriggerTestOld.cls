@isTest(seeAllData=false)
public class projectTriggerTestOld {

    @isTest static  void testRestrictDeletion() {
        Care_Products__c prod1 = new Care_Products__c(Name='prod 1');
        insert prod1;
        Project_Group__c ProjGroup = new Project_Group__c(Name='PGroup 1', Care_Product__c=prod1.Id);
        insert ProjGroup;
        project__c proj1 = new project__c(Name='Project 1', Project_Status__c='Live', Project_Group__c=ProjGroup.Id);
        project__c proj2 = new project__c(Name='Project 2', Project_Status__c='Draft in Review', Project_Group__c=ProjGroup.Id);
        project__c proj3 = new project__c(Name='Project 3', Project_Status__c='Draft Project Approved',Project_Group__c=ProjGroup.Id);
        project__c proj4 = new project__c(Name='Project 4', Project_Status__c='Closed',Project_Group__c=ProjGroup.Id);
       

        List<project__c> projectList = new List<project__c>{proj1, proj2, proj3, proj4};
            
        insert projectList;
        
        

        try {
            delete projectList;
        } catch (DmlException e) {
            String expectedErrorMessage = 'You can not delete Project if its Status is';
            for (Integer i = 0; i < projectList.size(); i++) {
                if (projectList[i].Project_Status__c == 'Live' || projectList[i].Project_Status__c == 'Draft in Review' 
                    || projectList[i].Project_Status__c == 'Draft Project Approved' || projectList[i].Project_Status__c == 'Closed') {
                    System.assertEquals(expectedErrorMessage, e.getDmlMessage(i));
                }
            }
        }

       
      }

    @isTest static  void testRestrictUpdation() {
        Care_Products__c prod1 = new Care_Products__c(Name='prod 1');
        insert prod1;
        Project_Group__c ProjGroup = new Project_Group__c(Name='PGroup 1', Care_Product__c=prod1.Id);
        insert ProjGroup;
        project__c proj1 = new project__c(Name='Project 1', Project_Status__c='Live', Project_Group__c=ProjGroup.Id);
        project__c proj2 = new project__c(Name='Project 2', Project_Status__c='Draft in Review', Project_Group__c=ProjGroup.Id);
        project__c proj3 = new project__c(Name='Project 3', Project_Status__c='Draft Project Approved', Project_Group__c=ProjGroup.Id);
        project__c proj4 = new project__c(Name='Project 4', Project_Status__c='Closed', Project_Group__c=ProjGroup.Id);
       

        List<project__c> projectList = new List<project__c>{proj1, proj2, proj3, proj4};
           
        insert projectList;
            
        for (project__c proj : projectList) {
            proj.Name = 'New Name';
        }

        

        try {
            update projectList;
        } catch (DmlException e) {
            String expectedErrorMessage = 'You can not update Project if its Status is';
            for (Integer i = 0; i < projectList.size(); i++) {
                if (projectList[i].Project_Status__c == 'Live' || projectList[i].Project_Status__c == 'Draft in Review' 
                    || projectList[i].Project_Status__c == 'Draft Project Approved' || projectList[i].Project_Status__c == 'Closed') {
                    System.assertEquals(expectedErrorMessage, e.getDmlMessage(i));
                }
            }
        }

        
    }
}