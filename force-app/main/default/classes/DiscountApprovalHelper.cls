public class DiscountApprovalHelper {
	// Function for Invoking Approval Process After Insert
    public void handleAfterInsert(List<Book__c> newList) {
        for(Book__c book : newList){
            // Checking if entry criteria met?
            if(book.Discount__C >= 10 && book.Status__c != 'Approved'){
                
                // Creating/Invoking approval process for the book object
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval. Please approve.');
                req.setObjectId(book.Id);
                Approval.ProcessResult result = Approval.process(req);
                System.debug('Submitted for approval successfully: '+result.isSuccess());
            }
        }
    }
    
    // Function for Invoking Approval Process After Update
    public void handleAfterUpdate(List<Book__c> oldList , List<Book__c> newList) {
        for(integer i=0; i<newList.size(); i++){
            
            // Checking if entry criteria met?
            if(newList[i].Discount__c != oldList[i].Discount__c && newList[i].Discount__c >=10){
               	
                // Creating/Invoking approval process for the book object
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval. Please approve.');
                req.setObjectId(newList[i].Id);
                Approval.ProcessResult result = Approval.process(req);
                System.debug('Submitted for approval successfully: '+result.isSuccess());
            }
        }
    }
    
    // Funtion to update approval status if criteria is not met
    public void handleBeforeUpdate(List<Book__c> newList , List<Book__c> oldList){
        for(integer i=0; i<newList.size(); i++){
            if(newList[i].Discount__c <10){
                newList[i].Status__c = 'Not Required';
            }
        }
    }
}