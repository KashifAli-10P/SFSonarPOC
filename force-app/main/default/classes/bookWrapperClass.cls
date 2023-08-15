public class bookWrapperClass {
    public Book__c book{get; set;}
    public Boolean isSelected{get; set;}
    
    public bookWrapperClass(Book__c book,Boolean isSelected){
        this.book = book;
        this.isSelected  = isSelected;
    }
}