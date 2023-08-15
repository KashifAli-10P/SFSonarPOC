trigger BookDiscountApproval on Book__c (before insert , before update , after insert , after update) {
	//Helper class Instance
    DiscountApprovalHelper dph = new DiscountApprovalHelper();
    
    // Method Call to do after insert functionality
    if (Trigger.isAfter && Trigger.isInsert ) {
        dph.handleAfterInsert(Trigger.new);
    }
   	
    // Method call to do after update functionality
    else if (Trigger.isAfter && Trigger.isUpdate ) {
        dph.handleAfterUpdate(Trigger.old , Trigger.new);
    }
    
    // Method call to update the Book Approval Status before insertion
    else if(Trigger.isBefore && Trigger.isUpdate){
        dph.handleBeforeUpdate(Trigger.new , Trigger.old);
    }
}