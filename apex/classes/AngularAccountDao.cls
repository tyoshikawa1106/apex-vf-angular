public with sharing class AngularAccountDao {

    /**
     * コンストラクタ
     */
    public AngularAccountDao() {
        
    }

    /**
     * 取引先に紐付く取引先責任者を取得
     */
    public List<Contact> getContacts(String accountId) {
        return [SELECT Id,LastName,FirstName,LeadSource,Description FROM Contact WHERE AccountId =: accountId LIMIT 200];
    }

    /**
     * 削除対象の取引先責任者を取得
     */
    public List<Contact> getDeleteContacts(Set<Id> delContactIds) {
        return [SELECT Id FROM Contact WHERE Id IN: delContactIds];
    }
}