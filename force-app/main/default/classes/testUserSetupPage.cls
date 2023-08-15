@isTest
public class testUserSetupPage {
    @isTest public static void testgetAllUsers(){
        userSetupController usc = new userSetupController();
        String sortOrder = usc.sortingOrder;
        string s = 'Customer Community Login';
        List<User> expected = database.query('select name,email,read__c,write__c from user where Profile.UserLicense.Name =:s Order By Name '+sortOrder);
        List<User> actual = usc.getAllUsers();
        system.assertEquals(expected, actual);
    }
    @isTest public static void testgetData(){
        userSetupController usc = new userSetupController();
        test.startTest();
        usc.getData();
        test.stopTest();
    }
    @isTest public static void testCancel(){
        userSetupController usc = new userSetupController();
        PageReference actual = usc.Cancel();
        PageReference expected = new PageReference('/apex/UserSetupPage');
        system.assertEquals(expected.getUrl(), actual.getUrl());
    }
    @isTest public static void testsendEmail(){
        userSetupController usc = new userSetupController();
        PageReference actual = usc.sendEmail();
        PageReference expected = new PageReference('/apex/sendEmail?id='+usc.selectedId);
        system.assertEquals(expected.getUrl(), actual.getUrl());
    }
    @isTest public static void testselectAllDefault(){
        userSetupController usc = new userSetupController();
        usc.selectAll();
    }
    @isTest public static void testselectAllNegative(){
        userSetupController usc = new userSetupController();
        usc.checkAll = true;
        usc.selectAll();
    }
    @isTest public static void testSortUsersDefault(){
        userSetupController usc = new userSetupController();
        usc.sortingOrder = 'ASC';
        usc.sortUsers();
    }
    @isTest public static void testSortUsersNegative(){
        userSetupController usc = new userSetupController();
        usc.sortingOrder = 'DESC';
        usc.sortUsers();
    }
    @isTest public static void testtoggleHeaderDefault(){
        userSetupController usc = new userSetupController();
        usc.sortingOrder = 'ASC';
        usc.toggleHeader();
    }
    @isTest public static void testtoggleHeaderNegative(){
        userSetupController usc = new userSetupController();
        usc.sortingOrder = 'DESC';
        usc.toggleHeader();
    }
    @isTest public static void testemailSelected(){
        String expectedAddress = '';
        userSetupController usc = new userSetupController();
        for(userWrapperClass uwc : usc.wrappers){
            uwc.isSelected = true;
        }
        PageReference actual = usc.emailSelected();
        PageReference expected = new PageReference('/apex/sendEmail'); 
        for(userWrapperClass uwc : usc.wrappers){
            if(uwc.isSelected == true){
                expectedAddress = expectedAddress + uwc.usr.Email+',';
            }
            system.debug('----->'+expectedAddress);
        }
        system.assertEquals(expectedAddress, usc.addresses);
        system.assertEquals(expected.getUrl(), actual.getUrl());
    }
    @isTest public static void testEditUser(){
        userSetupController usc = new userSetupController();
        usc.editUser();
    }
    @isTest public static void testSendEmailMethod(){
        userSetupController usc = new userSetupController();
        for(userWrapperClass uwc : usc.wrappers){
            uwc.isSelected = true;
        }
        usc.emailSelected();
        PageReference actual =  usc.sendEmailMethod();
        PageReference expected = new PageReference('/apex/UserSetupPage');
        system.assertEquals(expected.getUrl(), actual.getUrl());
    }
    @isTest public static void testSendEmailMethodNegative(){
        userSetupController usc = new userSetupController();
        usc.emailSelected();
        PageReference actual =  usc.sendEmailMethod();
    }
    @isTest public static void testDeleteSelected(){
        userSetupController usc = new userSetupController();
        for(integer i=0;i<usc.wrappers.size();i++){
            if(i/2 == 0){
                usc.wrappers[i].isSelected = true;
            }
        }
        PageReference actual =  usc.deleteSelected();
        PageReference expected = new PageReference('/apex/UserSetupPage');
        system.assertEquals(expected.getUrl(), actual.getUrl());
    }
    @isTest public static void testDeleteSelectedNegative(){
        userSetupController usc = new userSetupController();
        
    }
    @isTest public static void testDeleteUserMethod(){
		userSetupController usc = new userSetupController();
        string s = 'Customer Community Login';
        User u = database.query('select name,email,read__c,write__c from user where Profile.UserLicense.Name =:s Order By Name limit 1');
		usc.selectedUser = u;
        PageReference actual = usc.deleteUser();
		PageReference expected = new PageReference('/apex/UserSetupPage');
        system.debug('Expected in delete user:'+expected+'Actual in delete user:'+actual);
		system.assertEquals(expected.getUrl(), actual.getUrl());        
    }
    @isTest public static void testSave(){
        userSetupController usc = new userSetupController();
  		string s = 'Customer Community Login';
        User u = database.query('select name,email,read__c,write__c from user where Profile.UserLicense.Name =:s Order By Name limit 1');
		u.Selected__c = null;
        usc.selectedUser = u;
        usc.Save();
    }
    @isTest public static void testSaveBothTrue(){
        userSetupController usc = new userSetupController();
  		string s = 'Customer Community Login';
        User u = database.query('select name,email,read__c,write__c from user where Profile.UserLicense.Name =:s Order By Name limit 1');
		u.Selected__c = null;
        u.Read__c = true;
        u.Write__c = true;
        usc.selectedUser = u;
        usc.Save();
    }
    @isTest public static void testSaveReadTrue(){
        userSetupController usc = new userSetupController();
  		string s = 'Customer Community Login';
        User u = database.query('select name,email,read__c,write__c from user where Profile.UserLicense.Name =:s Order By Name limit 1');
		u.Selected__c = null;
        u.Read__c = true;
        u.Write__c = false;
        usc.selectedUser = u;
        usc.Save();
    }
    @isTest public static void testSaveWriteTrue(){
        userSetupController usc = new userSetupController();
  		string s = 'Customer Community Login';
        User u = database.query('select name,email,read__c,write__c from user where Profile.UserLicense.Name =:s Order By Name limit 1');
		u.Selected__c = null;
        u.Read__c = false;
        u.Write__c = true;
        usc.selectedUser = u;
        usc.Save();
    }
    @isTest public static void testSavePermSetExists(){
        userSetupController usc = new userSetupController();
  		string s = 'Customer Community Login';
        //User u = database.query('select name,email,read__c,write__c from user where Profile.UserLicense.Name =:s Order By Name limit 1');
		Profile p = [Select id from Profile where Name = 'Customer Profile'];
        String permSetId = [SELECT Id FROM PermissionSet WHERE Label = 'ReadBookPermissionSet' LIMIT 1].Id;
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, Read__c = true, Write__c = false, contactId = '0032v000036HiqQAAS',
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        insert u;
        PermissionSetAssignment psa = new PermissionSetAssignment
                    (PermissionSetId = permSetId, AssigneeId = u.id);
        upsert psa;
        system.debug('New User:'+u);
        system.debug('----->'+psa);
        usc.selectedUser = u;
        system.debug('New User:'+usc.selectedUser);
        usc.Save1();
    }
    @isTest public static void testSavePermSetExistsVer2(){
        userSetupController usc = new userSetupController();
  		string s = 'Customer Community Login';
        //User u = database.query('select name,email,read__c,write__c from user where Profile.UserLicense.Name =:s Order By Name limit 1');
		Profile p = [Select id from Profile where Name = 'Customer Profile'];
        String permSetId = [SELECT Id FROM PermissionSet WHERE Label = 'ReadWriteBookPermissionSet' LIMIT 1].Id;
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, Read__c = false, Write__c = true, contactId = '0032v000036HiqQAAS',
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        insert u;
        PermissionSetAssignment psa = new PermissionSetAssignment
                    (PermissionSetId = permSetId, AssigneeId = u.id);
        upsert psa;
        system.debug('New User:'+u);
        system.debug('----->'+psa);
        usc.selectedUser = u;
        system.debug('New User:'+usc.selectedUser);
        usc.Save1();
    }
}