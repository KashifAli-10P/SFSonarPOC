public class OppHandler implements OppHandlerInterface{
    public Boolean isDisabled(){
        return true;
    }
    public void beforeInsert(List<SObject> newOpps){
        //before insert functionality
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        //before update functionality
    }
    public void beforeDelete(Map<Id, SObject> oldItems){
        //before delete functionality
    }
    public void afterInsert(List<SObject> newItems){
        //after insert functionality
        SObject o = newItems[0];
        Schema.SObjectType type = o.getSObjectType();
        system.debug('----->type:'+type);
        for(SObject s : newItems){
            
        }
        
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        //after update functionality
        
    }
    public void afterDelete(Map<Id, SObject> oldItems){
        //after delete functionlity
    }
    public void afterUndelete(Map<Id, SObject> oldItems){
        //after undelete functionality
    }
}