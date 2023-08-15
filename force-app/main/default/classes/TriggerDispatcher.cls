public class TriggerDispatcher {
    public static void Run(OppHandlerInterface ohi){
        //before insert/update/delete
        if(trigger.isBefore){
            if(trigger.isInsert){
                ohi.beforeInsert(trigger.new);
            }
            if(trigger.isUpdate){
                ohi.beforeUpdate(trigger.newMap, trigger.oldMap);
            }
            if(trigger.isDelete){
                ohi.beforeDelete(trigger.oldMap);
            }
        }
        //after insert/update/delete
        if(trigger.isAfter){
            if(trigger.isInsert){
                ohi.afterInsert(trigger.newMap);
            }
            if(trigger.isUpdate){
                ohi.afterUpdate(trigger.newMap, trigger.oldMap);
            }
            if(trigger.isDelete){
                ohi.afterDelete(trigger.oldMap);
            }
            if(trigger.isUndelete){
                ohi.afterUndelete(trigger.oldMap);
            }
        }
	}
}