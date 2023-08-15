public class userWrapperClass {
    public User usr {get; set;}
    public Boolean isSelected {get; set;}
    
    public userWrapperClass(User usr , Boolean isSelected){
        this.usr = usr;
        this.isSelected = isSelected;
    }
}