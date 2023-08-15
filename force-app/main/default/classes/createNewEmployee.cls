public class createNewEmployee {
    public employee__c employee{get; set;}
    public List<employee__c> employees{get; set;}
    public Id empId{get; set;}
    public createNewEmployee(){
        empId = ApexPages.currentPage().getParameters().get('rid');
        if(empId == null){
            employee = new employee__c();
        }else{
            employee =[select name,email__c,phone__c,address__c,title__c from employee__c where id=:empId limit 1];
        }
		getEmployees();
    }
    public List<employee__c> getEmployees(){
        employees = [select ID,name,email__c,phone__c,address__c,title__c from employee__c];
        return employees;
    }
    public PageReference save(){
        //empId = ApexPages.currentPage().getParameters().get('empId');
        try{
            PageReference rf;
            upsert employee;
            rf = new PageReference('/apex/showAllEmployees');
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Employee was Saved');
            ApexPages.addMessage(msg);
            rf.setRedirect(true);
            return rf;
        }
        catch(DMLexception e){
            system.debug('Following eception occurd:'+e);
            return null;
        }
    }
    public PageReference createNew(){
        PageReference ref = new PageReference('/apex/newEmployee');
        ref.setRedirect(true);
        return ref;
    }
    
    public PageReference Edit(){
        employee = [select name,email__c,phone__c,address__c,title__c from employee__c where id=:empId limit 1];
        //system.debug(employee);
        PageReference ref = Page.newEmployee;
        ref= new PageReference('/apex/newEmployee?rid='+empId);
        ref.setRedirect(true);
        return ref;
    }
    public PageReference DeleteEmployee(){
        //empId = ApexPages.currentPage().getParameters().get('empId');
        employee__c delEmp = [select name,email__c,phone__c,address__c,title__c from employee__c where id=:empId limit 1];
        delete delEmp;
        PageReference ref = new PageReference('/apex/showAllEmployees');
        ref.setRedirect(true);
        return ref;
    }
}