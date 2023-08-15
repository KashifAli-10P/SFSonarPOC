trigger forAccountSalesforceUnification on Account (after insert , after update ) {
    if(String.valueOf(URL.getCurrentRequestUrl()).toLowerCase().contains('services/') && 
       (String.valueOf(URL.getCurrentRequestUrl()).toLowerCase().contains('tooling/'))==false || system.isFuture() == true){
        return;
    }
    if((trigger.isInsert && trigger.isAfter) || (trigger.isUpdate && trigger.isAfter)){
        String upload = JSON.serialize(trigger.new);
        //postAccountUsingRESTAPI.ctrl = true;
        postAccountUsingRestApi.callPost(upload);
        system.debug('Old Trigger Called.');
    }
}