public class GetContactsTree {
	@AuraEnabled
    public static List<Contact> getContacts(){
        return [Select Id, FirstName, LastName, Email, AccountId from Contact];
    }
}