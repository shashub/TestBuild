public class AccountService {

    public List<Account> getAccounts(){
        
        return [SELECT Id,Name from Account Limit 100];
    }
    
    public List<Contact> getContacts(){
        
        return [SELECT Id,Name from Contact Limit 100];
    }
}