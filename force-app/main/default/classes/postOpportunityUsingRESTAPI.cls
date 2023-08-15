public class postOpportunityUsingRESTAPI {
	public static final String clientId = '3MVG9G9pzCUSkzZuMsiOXHkDFR2nuRpqC5eIhVjYW3Mn_SOyWAD4onJjM_WLQSYztWDWwOHJY.DpJO34r6zEv';
    public static String clientSecret = '9CC2693EF52505FD977FF2200C192C0E44DAABDC02009D8023E7A6746856DC23';
    public static String username = 'kashifali781@tkxel.com';
    public static String password = 'kashifali789LH44k3yubAdHtYHxjwIEIhajx';
	public static boolean ctrl = false;
    public static String ReturnAccessToken (){
        Httprequest req = new HttpRequest();    
        req.setMethod('POST');    
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        
        req.setBody('grant_type=password' + '&client_id='+clientId + 
            '&client_secret='+clientSecret + '&username='+username + '&password='+password);  
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');        
        Http http = new Http();
        HttpResponse res;       
        String Access_Token;
        try {
            res = http.send(req);                
            system.debug('---->body:'+res.getBody());  
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                        parser.nextToken();
                        Access_Token = parser.getText();    
                        } 
                }            
        }catch(system.CalloutException e){            
            system.debug('error'+e);
        }
        //system.debug('------>access token:'+Access_Token);
        return Access_Token;
    }
    
    @future (callout = true)
    public static void callPost(String dataUpload){
        String accessToken;
        accessToken = ReturnAccessToken();
        if(accessToken != null){
          Http h = new Http();
          HttpRequest req = new HttpRequest();
          req.setMethod('POST');
          req.setHeader('Authorization','Bearer '+accessToken);
          req.setHeader('Content-Type','application/json; charset=UTF-8'); 
          req.setHeader('Accept','application/json');
          req.setEndpoint('https://ap15.salesforce.com/services/apexrest/oldToNewOLI/');   
          req.setBody(dataupload);
          HttpResponse res; 
            try{
                res = h.send(req);
                system.debug('--------Request sent successfully--------'+res);
            }catch(Exception e){
                system.debug('An error occured while synchnorizing orgs. Error is:'+e);
            }
          List<Opportunity> opL = (List<Opportunity>)JSON.deserialize(dataUpload, List<Opportunity>.class);
		  List<Id> oppResponseId = (List<Id>)JSON.deserialize(res.getBody(), List<Id>.class);
          system.debug('--->Response Opp id'+oppResponseId);
          system.debug('--->Opportunities'+opL);  
          Integer i = 0;
          List<Opportunity> temp = new List<Opportunity>();  
            for(Opportunity o : opL){
                Opportunity op = new Opportunity();
                op = o.clone();
                op.Id = o.Id;
                op.otherOrgOpp__c = oppresponseId[i];
                temp.add(op);
                i++;
            }
            system.debug('---->Opportunity toUpdate'+temp);
            try{
                update temp;
            }catch(Exception e){
                system.debug('--->An error occured while adding other org id.');
            }
        }
    }
}