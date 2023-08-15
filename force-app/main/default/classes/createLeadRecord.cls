@RestResource (urlMapping = '/createLead/')
global without sharing class createLeadRecord {
    @HttpPost
    global static String createLead(){
        Lead newLead = new Lead();
        String returnID = '';
        RestRequest req = RestContext.request;
        String reqBody = req.requestBody.ToString();
        System.debug('====>Req Body:'+reqBody);
        if(String.isNotBlank(reqBody) || String.isNotEmpty(reqBody)){
            try{
                newLead = (Lead)JSON.deserialize(reqBody, Lead.class);
                System.debug('====>Lead:'+newLead);
                if(newLead.Id != Null){
                    Database.update(newLead);
                    returnID = newLead.Id;
                }else if(newLead.Id == Null){
                    Database.insert(newLead);
                    returnID = newLead.Id;
                }
            }catch(Exception e){
                system.debug('=====>'+e.getMessage());
                return 'Failure';
            }
        }
        return 'Success';
    }
}