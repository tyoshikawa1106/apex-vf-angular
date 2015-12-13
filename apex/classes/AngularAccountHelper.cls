public with sharing class AngularAccountHelper {
    
    /**
     * コンストラクタ
     */
    public AngularAccountHelper() {

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
    public List<Contact> getContactsByApexMap(Map<Integer, AngularAccountApexContact> apexContactMap, Id accountId) {
        List<Contact> contacts = new List<Contact>();
        for (Integer key : apexContactMap.keySet()) {
            if (apexContactMap.containsKey(key)) {
                // 取引先責任者情報取得
                Contact c = apexContactMap.get(key).contact;
                c.AccountId = accountId;
                // 変更判定フラグ取得
                Boolean isChanged = false;
                if (apexContactMap.get(key).isChanged != null) {
                    isChanged = apexContactMap.get(key).isChanged;
                }
                // IDなし(新規) or 値変更(更新)の場合、登録対象としてリストに追加
                if (String.isEmpty(c.Id) || isChanged) {
                    contacts.add(c);
                }
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