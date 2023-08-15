@isTest
public class testEmployeeController {
    @isTest public static void TestgetEmployees(){
        List<employee__c> actual= [Select name,email__c,phone__c,address__c,title__c from employee__c];
        createNewEmployee e = new createNewEmployee();
        List<employee__c> expected = e.getEmployees();
        system.assertEquals(expected, actual);
    }
    @isTest public static void TestCreateNewPage(){
        createNewEmployee e = new createNewEmployee();
        PageReference expected = e.createNew();
        PageReference actual = new PageReference('/apex/newEmployee');
        system.assertEquals(expected.getUrl(), actual.getUrl());
    }
    @isTest public static void TestEdit(){
        createNewEmployee e = new createNewEmployee();
        PageReference expected = e.Edit();
        Id eid = e.empId;
        PageReference actual = new PageReference('/apex/newEmployee?rid='+eid);
        //system.debug(expected+' '+actual);
        system.assertEquals(expected.getUrl(), actual.getUrl());
    }
    @isTest public static void TestDelete(){
        createNewEmployee e = new createNewEmployee();
        PageReference expected = e.DeleteEmployee();
        PageReference actual = new PageReference('/apex/showAllEmployees');
        system.debug(expected+' '+actual);
        system.assertEquals(expected.getUrl(), actual.getUrl());
    }
    @isTest public static void TestSave(){
        createNewEmployee e = new createNewEmployee();
        PageReference expected = e.save();
        PageReference actual = new PageReference('/apex/showAllEmployees');
        system.assertEquals(expected.getUrl(), actual.getUrl());
    }
}