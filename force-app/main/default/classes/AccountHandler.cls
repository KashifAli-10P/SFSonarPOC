public with sharing class AccountHandler {
    public static password = 'testKashif';
    public static void CreateNewOpportunity(List<Account> accts) {
        List<Opportunity> opps = new List<Opportunity>();
        for (Account a : accts) {
            //Adding comments to commit
            //Second comment
            Opportunity opp = new Opportunity();
            opp.Name = a.Name + ' Opportunity';
            opp.AccountId = a.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.Today().addMonths(1);
            opps.add(opp);
        }
        if (opps.size()>0){
            insert opps;
        }
    }
}