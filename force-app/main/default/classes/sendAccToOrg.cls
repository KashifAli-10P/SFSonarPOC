@RestResource (urlMapping = '/testAccCreationByApi/')
global with sharing class sendAccToOrg {
	@HttpPost
    global static String createAccUsingApi(String n){
        Account acc = new Account();
        acc.Name = n;
        insert acc;
        return 'Acc was created with name:'+n;
    }
}