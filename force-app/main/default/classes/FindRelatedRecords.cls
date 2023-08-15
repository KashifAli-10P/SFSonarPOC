public class FindRelatedRecords {
	@AuraEnabled
    public List<Contact> getRelated(){
        String recordUrl = ApexPages.currentPage().getURL();
        System.debug('---->'+recordUrl);
        return [Select Id,FirstName,LastName,AccountId from Contact where AccountId =: recordUrl];
    }
}