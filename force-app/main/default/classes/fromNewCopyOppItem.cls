@RestResource (urlMapping = '/newToOldOppItem/')
global with sharing class fromNewCopyOppItem {
	@HttpPost
    global static List<String> createNewOpps(){
        List<OpportunityLineItem> newOppList = new List<OpportunityLineItem>();
        RestRequest req = RestContext.Request;
        RestResponse res = RestContext.Response;
        string req_body = req.RequestBody.ToString();
        if (req_body != NULL){
           newOppList = (List<OpportunityLineItem>)Json.deserialize(req_body,List<Opportunity>.class);
           List<OpportunityLineItem> toInsert = new List<OpportunityLineItem>(); 
           List<Opportunity> oppLine = new List<Opportunity>();
           List<Id> responseId = new List<Id>();
		   List<String> oppId = new List<String>();
           List<String> pdei = new List<String>();
            try{
                for(OpportunityLineItem o : newOppList){
                    oppId.add(o.OpportunityId);
                    pdei.add(o.PricebookEntryId);
                }
            } catch(Exception e){
                system.debug('An error occured:'+e);   
            }
           if (newOppList != NULL){
               for(OpportunityLineItem o : newOppList){
                   if(o.otherOrgOLI__c == null){
                       OpportunityLineItem oliTemp = new OpportunityLineItem();
                       oliTemp.OpportunityId = null; 
                   //toInsert.add(new Opportunity(name = o.Name , newOrgOpp__c = o.id, StageName = o.StageName , CloseDate = o.CloseDate));
                   }
               }
               try{
                   upsert toInsert;
                   system.debug('------>Opportunities were added:'+newOppList);
               }catch(Exception e){
                   system.debug('An error occured while adding accounts.Error is: '+e);
               }
           }
            for(OpportunityLineItem o : newOppList){
                responseId.add(o.Id);
            }
            if(responseId.size()>0){
                return responseId;
            }
         }
        	return null;
    }
}