public class CasesIntegrationHandler {
    public Case newCase {get; set;}
    
    public String noCasesMessage {get; set;}
    public Boolean noCaseShow {get; set;}
    public Boolean showCases {get; set;}
    
    public List<CaseWrapper> caseWrapList {get; set;}
    
    public class CaseWrapper{
        public Case currCase {get; set;}
        public Boolean isSelected {get; set;}
        
        public CaseWrapper(Case c){
            currCase = c;
            isSelected = false;
        } 
    }
    
    public class CaseSaveWrapper{
        public string caseId;
        public string caseSubj;
        public string caseReason;
        public string caseType;
        public string caseStatus;
        public string caseOrigin;
        public string casePriority;
        public string caseDescription;
        
        public CaseSaveWrapper(Case cs){
            caseId = cs.Id;
            caseSubj = cs.Subject;
            caseReason = cs.Reason;
            caseType = cs.Type;
            caseStatus = cs.Status;
            caseOrigin = cs.Origin;
            casePriority = cs.Priority;
            caseDescription = cs.Description;
        }
    }
    
    public class ResponseWrapper{
        public string statusCode;
        public string message;
        public string caseId;
    }
    
    public CasesIntegrationHandler(){
        List<Case> existingCases = new List<Case>();
        
        caseWrapList = new List<CaseWrapper>();
        newCase = new Case();
        
        try{
            existingCases = [SELECT Id, IsDeleted, MasterRecordId, CaseNumber, ContactId, AccountId, AssetId, SourceId, ParentId, 
                             SuppliedName, SuppliedEmail, SuppliedPhone, SuppliedCompany, Type, Status, Reason, Origin, Subject, 
                             Priority, Description, IsClosed, ClosedDate, IsEscalated, OwnerId, CreatedDate, CreatedById, LastModifiedDate,
                             LastModifiedById, SystemModstamp, ContactPhone, ContactMobile, ContactEmail, ContactFax, Comments, LastViewedDate,
                             LastReferencedDate, EngineeringReqNumber__c, SLAViolation__c, Product__c, PotentialLiability__c FROM Case 
                             ORDER BY CreatedDate DESC LIMIT 20];
            
            for(Case cs : existingCases){
                caseWrapList.add(new CaseWrapper(cs));
            }
            noCaseShow = false;
            showCases = true;
        }catch(Exception ex){
            noCasesMessage = 'No case found in system. Try creating a new one.';
            noCaseShow = true;
        }
    }
    
    public PageReference saveCase(){
        try{
            insert newCase;
            CaseSaveWrapper cswrap = new CaseSaveWrapper(newCase);
            system.debug('CS Wrap:'+ cswrap);
            sendRequest(JSON.serialize(cswrap), 'POST');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Cases created successfully and sent for integration. Please check logs to see the result'));
            newCase = new Case();
            return new PageReference('/apex/CasesIntegration');
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
            return new PageReference('/apex/CasesIntegration'); 
        }
    }
    
    public PageReference updateCase(){
        try{
            update newCase;
            CaseSaveWrapper cswrap = new CaseSaveWrapper(newCase);
            system.debug('CS Wrap:'+ cswrap);
            sendRequest(JSON.serialize(cswrap), 'PATCH');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Cases created successfully and sent for integration. Please check logs to see the result'));
            newCase = new Case();
            return new PageReference('/apex/CasesIntegration');
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
            return new PageReference('/apex/CasesIntegration'); 
        }
    }
    
    public PageReference deleteCase(){
        try{
            CaseSaveWrapper cswrap = new CaseSaveWrapper(newCase);
            delete newCase;
            system.debug('CS Wrap:'+ cswrap);
            sendRequest(JSON.serialize(cswrap), 'DELETE');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Cases created successfully and sent for integration. Please check logs to see the result'));
            newCase = new Case();
            return new PageReference('/apex/CasesIntegration');
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
            return new PageReference('/apex/CasesIntegration'); 
        }
    }
    
    @future(callout=true)
    public static void sendRequest(String payload, String method){
        system.debug('Payload:'+payload);
        Map<String, String> payMap = (Map<String, String>) JSON.deserialize(payload, Map<String, String>.class);
        String caseId = payMap.get('caseId');
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SF_to_SF_Intg/services/apexrest/caseApi');
        req.setMethod(method);
        req.setBody(payload);
        system.debug('Req Body:'+req.getBody());
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String body = res.getBody();
        system.debug('Response===>:'+res.getBody());
        Object obj = JSON.deserializeUntyped(body);
        system.debug('Map:'+ obj);
        CasesIntegrationHandler.ResponseWrapper resMap = (CasesIntegrationHandler.ResponseWrapper)JSON.deserialize(String.valueOf(obj), CasesIntegrationHandler.ResponseWrapper.class);
        try{
            if(method != 'DELETE'){
               Case cs = [Select Id, External_Case__c from Case where Id =: caseId];
                cs.External_Case__c = resMap.caseId;
                update cs; 
            }
        }catch(Exception ex){system.debug('error:'+ex.getMessage());}
        system.debug('Response:'+res.getBody());
    }
    
    
    
    public PageReference cancel(){
        return new PageReference('/apex/CasesIntegration'); 
    }
}