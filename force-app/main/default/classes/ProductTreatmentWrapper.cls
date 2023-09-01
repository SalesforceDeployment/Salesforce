public class ProductTreatmentWrapper {

	public class Criteria {
        @AuraEnabled
		public String id;
        @AuraEnabled
		public String question;
	}
	@AuraEnabled
	public String treatmentName;
    @AuraEnabled
	public String treatmentId;
	@AuraEnabled
	public Boolean treatmentStatus;
    @AuraEnabled
	public List<Indications> indications;

	public class Indications {
        @AuraEnabled
		public String pcid;
        @AuraEnabled
		public String name;
        @AuraEnabled
		public String id;
        @AuraEnabled
		public List<DosingDetails> dosingDetails;
        @AuraEnabled
		public List<Criteria> inclusionCriteria;
        @AuraEnabled
		public List<Criteria> exclusionCriteria;
	}

	public class DosingDetails {
        @AuraEnabled
		public String id;
        @AuraEnabled
		public String productInformation;
        @AuraEnabled
		public String strength;
        @AuraEnabled
		public Decimal defaultQuantity;
	}

	@AuraEnabled
	public static List<ProductTreatmentWrapper> parse(String json) {
		return (List<ProductTreatmentWrapper>) System.JSON.deserialize(json, List<ProductTreatmentWrapper>.class);
	}
}