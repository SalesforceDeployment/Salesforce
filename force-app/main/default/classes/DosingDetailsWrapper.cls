public class DosingDetailsWrapper {

    public class DosingDetails {
	@AuraEnabled
	public Decimal DefaultQuantity;
	@AuraEnabled
	public Decimal ShippedQuantity;
    @AuraEnabled
	public Decimal reassignedQuantity;
	@AuraEnabled
	public String Id;
	@AuraEnabled
	public String Strength;
	@AuraEnabled
	public Boolean active;
	@AuraEnabled
	public String patientDosageRequestId;
    }

    @AuraEnabled
	public List<DosingDetails> dosingDetails = new List<DosingDetails>(); // other questions


	public static DosingDetailsWrapper parse(String json) {
		return (DosingDetailsWrapper) System.JSON.deserialize(json, DosingDetailsWrapper.class);
	}
}