public class getObjectFields {
	private static final String clientId = '3MVG9G9pzCUSkzZuMsiOXHkDFR2nuRpqC5eIhVjYW3Mn_SOyWAD4onJjM_WLQSYztWDWwOHJY.DpJO34r6zEv';
    private static String clientSecret = '9CC2693EF52505FD977FF2200C192C0E44DAABDC02009D8023E7A6746856DC23';
    private static String username = 'kashifali781@tkxel.com';
    private static String password = 'kashifali789LH44k3yubAdHtYHxjwIEIhajx';
    private static String ReturnAccessToken (){
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
    public static void getFields(){
        String accessToken;
        accessToken = ReturnAccessToken();
        if(accessToken != null){
          Http h = new Http();
          HttpRequest req = new HttpRequest();
          req.setMethod('POST');
          req.setHeader('Authorization','Bearer '+accessToken);
          req.setHeader('Content-Type','application/json; charset=UTF-8'); 
          req.setHeader('Accept','application/json');
          req.setEndpoint('https://ap15.salesforce.com/services/apexrest/sendTOPG/');
          String type = JSON.serialize('Account');
          req.setBody(JSON.serialize('Field_Mapping__c'));
          List<String> fields = new List<String>();
          HttpResponse res;
            try{
                res = h.send(req);
                String result = res.getBody();
                system.debug('-------->'+result);
                fields = (List<String>)JSON.deserialize(result, List<String>.class);
                system.debug('--------Request sent successfully--------');
            }catch(Exception e){
                system.debug('An error occured while synchnorizing orgs. Error is:'+e);
            }
            system.debug('---->Total Fields:'+fields.size());
            for (String s : fields){
                system.debug('---->'+s);
            }
        }
    }
}