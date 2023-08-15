public class UserSetUpController {
    public 	User curUser{get; set;}
    public List<User> users{get; set;}
    public User selectedUser {get; set;}
    public ID curID{get; set;}
    public ID selectedID {get; set;}
    public EmailTemplate email{get; set;}
    public List<String> sendTo{get; set;}
    public string addresses{get;set;}
    public String sortingOrder = 'ASC';
    public string header{get; set;}
    public Integer cols{get; set;}
    public Boolean checkAll{get; set;}
    public List<userWrapperClass> wrappers{get; set;}
    public UserSetupController(){
        selectedID = ApexPages.currentPage().getParameters().get('id');
        cols = 2;
        getData();
        sendTo = new List<String>();
        checkAll = false;
        header = 'Name ▼';
        if(selectedID != null){
         try{
                User u = [Select name,email,read__c,write__c from user where id =: selectedID];
                addresses = u.email;
            }
            catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
                system.debug('');
            }
        }
        try{
            email = [select EmailTemplate.Name , EmailTemplate.Body , EmailTemplate.Subject , EmailTemplate.Encoding , EmailTemplate.FolderName , EmailTemplate.id from EmailTemplate where EmailTemplate.Name = 'userEmail' limit 1];
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
        }
        selectedUser = new User();
    }
    
    // Funtion to assign users to the wrapper class
    public void getData(){
        wrappers = new List<userWrapperClass>();
        for(User u : getAllUsers()){
            wrappers.add(new userWrapperClass(u,false));
        }
    }
    
    // Save the user and assign the permission set according to the selected user.
    public PageReference Save(){
        PageReference ref = new PageReference('/apex/UserSetupPage');
        ref.setRedirect(true);
        // Getting the current logged in user
        curID = UserInfo.getUserId();
        curUser = [select name,selected__c from user where id=: curID];
        curUser.selected__c = selectedUser.selected__c;
       	selectedUser.selected__c = null;
        
        // Getting the selected user
        selectedUser.id = curUser.selected__c;
        return Save1();
    }
    
    //Another Version of save for test.
    public PageReference Save1(){
        PageReference ref = new PageReference('/apex/UserSetupPage');
        ref.setRedirect(true);
        if(selectedUser.Read__c == true && selectedUser.Write__c == true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Please select only 1 Option'));
            return null;
        }
        
        // if read option is selected then assign read permission set only
        else if(selectedUser.Read__c == true && selectedUser.Write__c == false){
            string permSetId;
            List<PermissionSetAssignment> curPermSet;
            try{
               	permSetId = [SELECT Id FROM PermissionSet WHERE Label = 'ReadBookPermissionSet' LIMIT 1].Id;	            
   	            curPermSet = [Select Id,PermissionSet.Name,AssigneeId from PermissionSetAssignment where AssigneeId =: selectedUser.id limit 1];
            }
            catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Please select only 1 Option'));
                return null;
            }
            // If no permission set is assigned then assign the read permission set
            if(curPermSet.size() == 0){
                PermissionSetAssignment psa = new PermissionSetAssignment
                    (PermissionSetId = permSetId, AssigneeId = selectedUser.id);
                try{
                    upsert psa;
                    update selectedUser;
                    return ref;
                }
                catch(DMLException e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
                    return null;
                }
                
            // if a permission set is assigned then first delete that 
            // and assign according to selected option.    
            }else {
                try{
                    List<PermissionSetAssignment> toDelete = [SELECT Id, AssigneeId, PermissionSetId
                    FROM PermissionSetAssignment WHERE 
                    AssigneeId =: selectedUser.id
                    AND PermissionSetId IN (SELECT Id FROM PermissionSet WHERE IsOwnedByProfile =false)];
                    delete toDelete;
                }
                catch(DMLException e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
                    return null;
                }
                // call assignPermissionSet
                PermissionSetAssignment psa = new PermissionSetAssignment
                (PermissionSetId = permSetId, AssigneeId = selectedUser.id);
                try{
                    upsert psa;
                    update selectedUser;
                    return ref;
                }
                catch(DMLException e){
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
                     return null;
                }
            }
            
        // Functionality for assigning ReadWrite Permission Set    
        }else {
            String permSetId = '';
            List<PermissionSetAssignment> curPermSet = new List<PermissionSetAssignment>();
            try{
                permSetId = [SELECT Id FROM PermissionSet WHERE Label = 'ReadWriteBookPermissionSet' LIMIT 1].Id;
                curPermSet = [Select Id,PermissionSet.Name,AssigneeId from PermissionSetAssignment where AssigneeId =: selectedUser.id limit 1];
            }catch(DMLException e){ ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e)); return null;
            }
            if(curPermSet.size() == 0){
                PermissionSetAssignment psa = new PermissionSetAssignment
                    (PermissionSetId = permSetId, AssigneeId = selectedUser.id);
                try{
                    upsert psa;
                    update selectedUser;
                    return ref;
                }
                catch(DMLException e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
                    return null;
                }
            }else {
                system.debug('Executiong if perm set exists.');
                try{
                    List<PermissionSetAssignment> toDelete = [SELECT Id, AssigneeId, PermissionSetId
                    FROM PermissionSetAssignment WHERE 
                    AssigneeId =: selectedUser.id
                    AND PermissionSetId IN (SELECT Id FROM PermissionSet WHERE IsOwnedByProfile =false)];
                	delete toDelete;
                }catch(Exception e){
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
                     return null;
                }
                PermissionSetAssignment psa = new PermissionSetAssignment
                (PermissionSetId = permSetId, AssigneeId = selectedUser.id);
                try{
                    upsert psa;
                    update selectedUser;
                    return ref;
                }
                catch(DMLException e){
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
                     return null;
                }
        	}
        }
    }
    
    // Geting all Users
    public List<User> getAllUsers(){
        try{
            string s = 'Customer Community Login';
            users = database.query('select name,email,read__c,write__c from user where Profile.UserLicense.Name =:s Order By Name ' + this.sortingOrder);
        	return users;
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
            return null;
        }
    }
        
    // Function to Edit the selected User
    public void editUser(){
        try{
            selectedUser = [select id,email,name,selected__c,read__c,write__c from user where id =: selectedID];
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
        }
        curID = UserInfo.getUserId();
        curUser = [select name,selected__c from user where id=: curID];
        curUser.Selected__c = selectedUser.id;
        selectedUser.Selected__c = curUser.Selected__c;
        //system.debug('user is'+selectedUser+'---'+curUser.Selected__c);
    }
    
    // Function to delete permission set assigned to selecte user
    public PageReference deleteUser(){
        List<PermissionSetAssignment> toDelete;
        try{
            selectedUser = [select id,name,selected__c,read__c,write__c from user where id =: selectedID limit 1];
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
        }
        selectedUser.Read__c = false;
        selectedUser.write__c = false;
        try{
             toDelete = [SELECT Id, AssigneeId, PermissionSetId
                    FROM PermissionSetAssignment WHERE 
                    AssigneeId =: selectedUser.id
                    AND PermissionSetId IN (SELECT Id FROM PermissionSet WHERE IsOwnedByProfile =false)];
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
        }
        try{
            delete toDelete;
            update selectedUser;
            PageReference ref = new PageReference('/apex/UserSetupPage');
            ref.setRedirect(true);
            return ref;
        }
        catch(DMLException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
            return null;
        }
    }

	// Function to redirect to sendEmail page    
    public PageReference sendEmail(){
        //system.debug(selectedID);
        PageReference ref = new PageReference('/apex/sendEmail?id='+selectedID);
		ref.setRedirect(true);
        return ref;      
    }
    
    // Function to send Email to Selected User
    public PageReference sendEmailMethod(){
        system.debug('-------->'+sendTo);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        system.debug('are we here in send email');
        sendTo = addresses.split(',');
        message.setToAddresses(sendTo);
        system.debug('are we here after setting addresses');
        system.debug(message.getToAddresses());
        message.setSubject(email.subject);
        message.setHtmlBody(email.body);
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            System.debug('Email sent Success fully');
            PageReference ref = new PageReference('/apex/UserSetupPage');
            ref.setRedirect(true);
            return ref;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message
            (ApexPages.severity.Warning,'An error occured while sending email'+e));
            return null;
        }
    }
    
    // Function to Cancel and Operation
    public PageReference Cancel(){
        PageReference ref = new PageReference('/apex/UserSetupPage');
        ref.setRedirect(true);
        return ref;
    }
    
    // Functions to sort users Ascending/Descending
    public void toggleHeader(){
        if(sortingOrder == 'ASC'){
            header = 'Name ▼';
            system.debug('-----'+header+'-------');
            sortUsers();
        }
        else{
            header = 'Name ▲';
            sortUsers();
            system.debug('-----'+header+'-------');
        }
    }
    public void sortUsers(){
        system.debug('sorting user');
        integer count = 0;
        if(sortingOrder == 'ASC'){
            sortingOrder = 'DESC';
            for(User u : getAllUsers()){
                wrappers[count].usr = u;
                count++;
            }
         }else if(sortingOrder == 'DESC'){
             sortingOrder = 'ASC';
             for(User u : getAllUsers()){
                wrappers[count].usr = u;
                count++;
            }
         }      
    }
    
    // Function to Select all in one click
    public void selectAll(){
        if(checkAll == false){
            for(userWrapperClass uwc : wrappers){
                uwc.isSelected = false;
                //system.debug(uwc.isSelected);
        	}
        }else{
            for(userWrapperClass uwc : wrappers){
            	uwc.isSelected = true;
                //addresses = addresses + uwc.usr.Email+',';
                //system.debug(uwc.isSelected);
        	}
        }
        //system.debug('----->all emails:'+sendTo);
    }
      
    // Function to Delete Permission Set 
    // assigned to all selected Users
    public PageReference deleteSelected(){
        List<PermissionSetAssignment> toDelete = new List<PermissionSetAssignment>();
        List<ID> permToDel = new List<ID>();
        List<User> usersToDel = new List<User>();
        for (userWrapperClass uwc : wrappers){
            if(uwc.isSelected == true){
                permToDel.add(uwc.usr.id);
                usersToDel.add(uwc.usr);
            }   
        }
        try{
             toDelete = [SELECT Id, AssigneeId, PermissionSetId
                    FROM PermissionSetAssignment WHERE 
                    AssigneeId IN :permToDel
                    AND PermissionSetId IN (SELECT Id FROM PermissionSet WHERE IsOwnedByProfile =false)];
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
        }
        if(usersToDel != null){
            for(User u : usersToDel){
                u.Read__c = false;
                u.Write__c = false;
            }
            try{
                delete toDelete;
                update usersToDel;
                PageReference ref = new PageReference('/apex/UserSetupPage');
                ref.setRedirect(true);
                return ref;
            }
            catch(DMLException e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
                return null;
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'There was a problem. Permission Set could not be deleted'));
            return null;                     
        }
    }
    
    // Function for Bulk Email
    public PageReference emailSelected(){
        sendTo = new List<String>();
        addresses = '';
        for (userWrapperClass uwc : wrappers){
            if(uwc.isSelected == true){
                addresses = addresses + uwc.usr.Email+',';
                //sendTo.add(ucw.usr.email);
            }
        }
        PageReference ref =new PageReference('/apex/sendEmail');
        return ref;
    }
}