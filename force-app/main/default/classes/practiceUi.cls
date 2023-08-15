public class practiceUi {
    public string userinterface{get;set;}
    public boolean isui{get;set;}
    public practiceUi(){
        userinterface = UserInfo.getUiThemeDisplayed();
        if(userinterface == 'Theme3'){
            isui = true;
        }
	}
}