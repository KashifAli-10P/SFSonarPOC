public class booksController {
    public book__c b{get; set;} 
    public Boolean checkAll{get; set;}
    public List<book__c> books{get; set;}
    public ID bId{get;  set;}
    public EmailTemplate email{get; set;}
    public List<bookWrapperClass> wrapperBooks{get;set;}
    public String addresses{get; set;}
    // Controller
    public booksController(){
        addresses = '';
        bId = ApexPages.currentPage().getParameters().get('rid');
        checkAll = false;
        getWrapperBooks();
        if(bId == null){
            b = new book__c();
        }else {
            try{
            	b= [Select id,name,price__c,author__c,publisher__c,discount__c,Status__c from book__c where id=:bId limit 1];
            }
            catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Error '+e+' occured'));
        	}
        }
        try{
            email = [select EmailTemplate.Name , EmailTemplate.Body , EmailTemplate.Subject , EmailTemplate.Encoding , EmailTemplate.FolderName , EmailTemplate.id from EmailTemplate where EmailTemplate.Name = 'userEmail' limit 1];
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Following error occured'+e));
        }
    }
    
    // setting wrapper books
    public List<bookWrapperClass> getWrapperBooks(){
        wrapperBooks = new List<bookWrapperClass>();
        for(Book__c b : getBooks()){
            wrapperBooks.add(new bookWrapperClass(b,false));
        }
        system.debug('total books are:'+wrapperBooks.size());
        return wrapperBooks;
    }
    
    // Function to save/update book
    public PageReference Save(){
        try{
            upsert b;
            PageReference ref = new PageReference('/apex/booksdetails');
            ref.setRedirect(true);
            return ref;
        }
        catch(DMLexception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'An error occured.Try again'));
            system.debug('Following error occured:'+e);
            return null;
        }
    }
    
    // Function to get all books to display
    public List<book__c> getBooks(){
        try{   
        	books = [Select id,Name,Price__c,Author__r.Email,Author__r.Name,Publisher__c,Discount__c,Status__c from book__c];
            //system.debug('Books are:'+books);
            return books;
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Error '+e+' occured'));
            return null;
        }
    }
    
    // Function to select and edit a book.
    public PageReference Edit(){
        try{
            b = [Select id,name,price__c,author__c,publisher__c,discount__c,Status__c from book__c where id=:bId limit 1];
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Error '+e+' occured'));
            return null;
        }
        system.debug(b);
        PageReference ref = new PageReference('/apex/booksdetails?rid='+bId);
        ref.setRedirect(true);
        return ref;
    }
    
    // Function to delete a selected book.
    public PageReference deleteBooks(){
        Book__c b1 = [Select id,name,price__c,author__c,publisher__c,discount__c,Status__c from book__c where id=:bId limit 1];
        try{
            delete b1;
            PageReference ref = new PageReference('/apex/booksdetails');
            ref.setRedirect(true);
            return ref;
        }
        catch(DMLexception e){
            system.debug('Following Excertion occured:'+e);
            return null;
        }
            
    }
   	
    public void selectAll(){
        if(checkAll == false){
            for(bookWrapperClass bwc: wrapperBooks){
                bwc.isSelected = false;
                
        	}
        }else{
            for(bookWrapperClass bwc : wrapperBooks){
            	bwc.isSelected = true;
            }
        }
       system.debug('------>'+wrapperBooks);
    }
    
    public PageReference deleteBulkBooks(){
        List<Book__c> booksToDel = new List<Book__c>();
        for(bookWrapperClass bwc : wrapperBooks){
            if(bwc.isSelected == true){
                booksToDel.add(bwc.book);
            }
        }
        try{
            delete booksToDel;
            
            PageReference ref = new PageReference('/apex/booksDetails');
            ref.setRedirect(true);
            return ref;
        }
        catch(DMLException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'An error occured.Try again'));
            return null;
        }
    }
    
    public PageReference emailSelected(){
        system.debug('---->'+wrapperBooks);
        for(bookWrapperClass bwc : wrapperBooks){
            if(bwc.isSelected == true){
                addresses = addresses + bwc.book.Author__r.Email+',';
            }
        }
        system.debug('--->address:'+addresses);
        PageReference ref = new PageReference('/apex/bookEmail');
        return ref;
    }
    public PageReference sendEmailMethod(){
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        String body = '';
        //system.debug('emails: ' + toAddress);
        for(integer i = 0; i < wrapperBooks.size(); i++){
            if(wrapperBooks[i].isSelected == true){
                body = 'Hi '+ wrapperBooks[i].book.Author__r.Name + ' ' + email.body;
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setTemplateId(email.Id);
                msg.setSubject(email.Subject);
                msg.setPlainTextBody(body);
                msg.setHtmlBody(body);
                msg.setUseSignature(false);
        		msg.setBccSender(false);
                //email.setToAddresses(toAddress[i]);
                msg.setTargetObjectId(wrapperBooks[i].book.Author__r.id);
                msg.setSaveAsActivity(false);
                mailList.add(msg);
                //system.debug('email body: ' + body);
            }
            
        }
        try{
            Messaging.sendEmail(mailList);
            SYSTEM.debug('MAIL SENT SUCCESSFULLY TO: ' + mailList.size() + ' people');
        	PageReference ref = new PageReference('/apex/booksDetails');
            return ref;
        }
        catch(EmailException e){
            system.debug('Could not send email: ' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'An error occured.Try again:'+e));
            return null;
        }
    }
    public PageReference Cancel(){
        PageReference ref = new PageReference('/apex/booksDetails');
        ref.setRedirect(true);
        return ref;
    }
}