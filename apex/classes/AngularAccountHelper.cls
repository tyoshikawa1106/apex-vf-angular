public with sharing class AngularAccountHelper {
    
    /**
     * コンストラクタ
     */
    public AngularAccountHelper() {

    }

    /**
     * 取引先のJSON文字列存在判定
     */
    public AngularAccountResult isEmptyAccountJSON(String accountJSON, AngularAccountResult result) {
        if (String.isEmpty(accountJSON)) {
            result.errorMessages.add('取引先のJSON文字列取得に失敗しました。');
            return result;
        }

        return result;
    }

    /**
     * 削除対象取引先責任者ID取得
     */
    public Set<Id> getDelContactIdsByJson(List<Object> jsonDelContactIdList) {
        Set<Id> delContactIds = new Set<Id>();
        for (Object item : jsonDelContactIdList) {
            delContactIds.add((String)item);
        }
        
        return delContactIds;
    }

    /**
     * 取引先取得
     */
    public Account getAccountByJson(Map<String, Object> jsonMap) {
        Account account = new Account();
        if (jsonMap.containsKey('Id') && String.isNotEmpty((String)jsonMap.get('Id'))) {
            account.Id = (String)jsonMap.get('Id');
        }
        if (jsonMap.containsKey('Name') && String.isNotEmpty((String)jsonMap.get('Name'))) {
            account.Name = (String)jsonMap.get('Name');
        }
        if (jsonMap.containsKey('AccountNumber') && String.isNotEmpty((String)jsonMap.get('AccountNumber'))) {
            account.AccountNumber = (String)jsonMap.get('AccountNumber');
        }

        return account;
    }

    /**
     * 取引先値判定
     */
    public AngularAccountResult isAccountValidation(Account account, AngularAccountResult result) {
        // 取引先値チェック
        if (String.isEmpty(account.Name)) {
            result.errorMessages.add('取引先名を入力してください。');
        }
        return result;
    }

    /**
     * 取引先責任者取得
     */
    public List<Contact> getContactsByJson(Id accountId, List<Object> jsonContactList) {

        List<Contact> contacts = new List<Contact>();
        for (Object item : jsonContactList) {
            Map<String, Object> itemMap = (Map<String, Object>)item;
            Boolean isChanged = false;

            Contact contact = new Contact();
            contact.AccountId = accountId;

            if (itemMap.containsKey('IsChanged')) {
                isChanged = (Boolean)itemMap.get('IsChanged');
            }
            if (itemMap.containsKey('Id') && String.isNotEmpty((String)itemMap.get('Id'))) {
                contact.Id = (Id)itemMap.get('Id');
            }
            if (itemMap.containsKey('LastName') && String.isNotEmpty((String)itemMap.get('LastName'))) {
                contact.LastName = (String)itemMap.get('LastName');
            }
            if (itemMap.containsKey('FirstName') && String.isNotEmpty((String)itemMap.get('FirstName'))) {
                contact.FirstName = (String)itemMap.get('FirstName');
            }
            if (itemMap.containsKey('LeadSource') && String.isNotEmpty((String)itemMap.get('LeadSource'))) {
                contact.LeadSource = (String)itemMap.get('LeadSource');
            }
            if (itemMap.containsKey('Description') && String.isNotEmpty((String)itemMap.get('Description'))) {
                contact.Description = (String)itemMap.get('Description');
            }
            // IDがなし(新規) or 値変更(更新)の場合、登録対象としてリストに追加
            if (String.isEmpty(contact.Id) || isChanged) {
                contacts.add(contact);
            }
        }

        return contacts;
    }

    /**
     * 取引先責任者値判定
     */
    public AngularAccountResult isContactValidation(List<Contact> contacts, AngularAccountResult result) {
        for (Contact c : contacts) {
            if (String.isEmpty(c.LastName)) {
                result.errorMessages.add('[取引先責任者] 未入力の姓項目があります');
            }
            if (String.isEmpty(c.FirstName)) {
                result.errorMessages.add('[取引先責任者] 未入力の名項目があります');
            }
            // エラー発生チェック
            if (!result.errorMessages.isEmpty()) {
                return result;
            }
        }
        return result;
    }
}