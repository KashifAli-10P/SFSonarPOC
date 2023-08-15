({
	ContactList : function() {
		var action = component.get('c.getRelated');
		var self = this;
		action.setCallback(this, function(actionResult) {
         component.set('v.RelatedContacts', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
      }
})