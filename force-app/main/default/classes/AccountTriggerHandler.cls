public class AccountTriggerHandler {
    public static void CreateAccounts(List<Account> ls){
        for(Account a : ls){
            if(a.ShippingState != a.BillingState){
                a.ShippingState = a.BillingState;
            }
        }
    }
}