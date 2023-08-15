@RestResource (urlMapping = '/newToOldAcc/')
global with sharing class restApiToCopyAccNew {
	@HttpPost
    global static List<String> createAccounts(){
        List<Account> newaccList = new List<Account>();
        RestRequest req = RestContext.Request;
        RestResponse res = RestContext.Response;
        List<String> accResponseId = new List<String>();
        string req_body = req.RequestBody.ToString();
        if (req_body != NULL){
           newAccList = (List<Account>)Json.deserialize(req_body,List<Account>.class);
           List<Account> toInsert = new List<Account>(); 
           List<String> otherIds = new List<String>();
           List<Account> acc = new List<Account>(); 
            try{
                acc = [Select otherOrgId__c from Account where otherOrgId__c != null];
                for(Account a : acc){
                    otherIds.add(a.otherOrgId__c);
                }
            } catch(Exception e){
                system.debug('An error occured:'+e);
                
            }
           if (newAccList != NULL){
               for(Account a : newAccList){
                   if(a.otherOrgId__c == null){
                       toInsert.add(a);
                   }else if(a.otherOrgId__c != null){
                       Account ac = new Account();
                       ac.Name = a.Name;
                       ac.Id = a.otherOrgId__c;
                       toInsert.add(ac);
                   }
               }
               try{
                   upsert toInsert;
                   system.debug('------>Accounts were added:'+newAccList);
               }catch(Exception e){
                   system.debug('An error occured while adding accounts.Error is: '+e);
               }
           }
            for(Account a : toInsert){
                accResponseId.add(a.Id);
            }
            if(accResponseId.size()>0){
                return accResponseId;
            }
         }
        return null;
    }
}