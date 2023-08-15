@RestResource (urlMapping = '/newToOldRestOpp/')
global with sharing class fromNewCopyOpp {
	@HttpPost
    global static List<String> createNewOpps(){
        List<Opportunity> newOppList = new List<Opportunity>();
        RestRequest req = RestContext.Request;
        RestResponse res = RestContext.Response;
        string req_body = req.RequestBody.ToString();
        if (req_body != NULL){
           newOppList = (List<Opportunity>)Json.deserialize(req_body,List<Opportunity>.class);
           List<Opportunity> toInsert = new List<Opportunity>();
           List<Id> oppResponseId = new List<Id>();
           List<String> accIds = new List<Id>();
            for(Opportunity o : newOppList){
                if(o.AccountId != null){
                    accIds.add(o.AccountId);
                }
            }
           Map<String,Account> linkAcc = new Map<String,Account>();
           List<Account> oppAcc = [SELECT Id,Name,OtherOrgId__c from Account where otherOrgId__c IN :accIds]; 
           system.debug('----->Opp account Ids:'+accIds);
           system.debug('----->Opp accounts:'+oppAcc);
            for(Integer i = 0; i<accIds.size(); i++){
                linkAcc.put(accIds[i],oppAcc[i]);
            }
            system.debug('--------->Map of Acc:'+linkAcc);
           if (newOppList != NULL){
               //integer i = 0;
               for(Opportunity o : newOppList){
                   if(o.otherOrgOpp__c == NULL){
                       Opportunity op = new Opportunity(Name =  o.Name, StageName = o.StageName, otherOrgOpp__c = o.id, CloseDate = o.CloseDate);
                       if(o.AccountId != NULL){
                           Account a = linkAcc.get(o.AccountId);
                           system.debug('mapped account'+a);
                           op.AccountId = a.Id;
                           system.debug('assiging account id:'+a);
                       }
                       system.debug('without org id');
                       toInsert.add(op);
                   }else if(o.otherOrgOpp__c != NULL){
                       Opportunity op = new Opportunity(Name =  o.Name, StageName = o.StageName, otherOrgOpp__c = o.id, CloseDate = o.CloseDate);
                       op.Id = o.otherOrgOpp__c;
                       Id temp = o.AccountId;
                       if(o.AccountId != NULL){
                           Account a = linkAcc.get(temp);
                           //system.debug('map account:'linkAcc.get(o.Id));
               			   system.debug('mapped account'+a);
                           op.AccountId = a.Id;
                           system.debug('assiging account id:'+a);
                       }
                       system.debug('with or id');
                       toInsert.add(op);
                       system.debug('Listed Account:'+op.AccountId);
                   }
               }
               try{
                   upsert toInsert;
                   system.debug('------>Opportunities were added:'+toInsert);
               }catch(Exception e){
                   system.debug('An error occured while adding accounts.Error is: '+e);
               }
           }
            for(Opportunity o : toInsert){
                oppResponseId.add(o.Id);
            }
            if(oppResponseId.size()>0){
                return oppResponseId;
            }
         }
         return null;
    }
}