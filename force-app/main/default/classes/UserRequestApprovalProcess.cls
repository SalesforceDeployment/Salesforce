// Used in ApprovalProcessRejectComponent 
public class UserRequestApprovalProcess {
	public String userRequestId {get;set;}
    Public ProcessInstanceStep pStep{get;set;}
    
    public ProcessInstanceStep getApprovalSteps() {
      if (userRequestId != null) {
        pStep = [SELECT SystemModstamp, 
                 		StepStatus, 
                 		ProcessInstanceId, 
                 		OriginalActorId,
                 		OriginalActor.Name,
        				Comments, 
                 		ActorId 
                 FROM ProcessInstanceStep 
                 WHERE ProcessInstance.TargetObjectId=:userRequestId 
                 ORDER BY SystemModstamp DESC LIMIT 1];  
        
      }
      return pStep ;
    }
    
    public ProcessInstanceStep getRejectSteps() {
      if (userRequestId != null) {
        pStep = [SELECT SystemModstamp, 
                 		StepStatus, 
                 		ProcessInstanceId, 
                 		OriginalActorId,
                 		OriginalActor.Name,
        				Comments, 
                 		ActorId 
                 FROM ProcessInstanceStep 
                 WHERE StepStatus = 'Rejected' and ProcessInstance.TargetObjectId=:userRequestId 
                 ORDER BY SystemModstamp DESC LIMIT 1];  
        
      }
      return pStep ;
    }
}