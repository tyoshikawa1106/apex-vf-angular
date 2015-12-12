public with sharing class AngularAccountController {

    private static AngularAccountHelper helper = new AngularAccountHelper();
    private static AngularAccountDao dao = new AngularAccountDao();

    // 取引先
    public Account account {get; set;}

    /**x
     * コンストラクタ
     */
    public AngularAccountController(ApexPages.StandardController stdController) {
        try {
            this.account = (Account)stdController.getRecord();    
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            return;
        }
    }
    
    /**
     * 取引先責任者取得
     */
    @RemoteAction
    public static List<Contact> getContacts(String accountId) {
        return dao.getContacts(accountId);
    }

    /**
     * 選択リスト値取得
     */
    @RemoteAction
    public static AngularAccountSelectListItem getAngularAccountSelectListItem() {
        AngularAccountSelectListItem result = new AngularAccountSelectListItem();
        // LeadSource選択リスト値取得
        result.leadSourceMap = result.getLeadSourceMap();

        return result;
    }

    /**
     * 保存処理実行
     */
    @RemoteAction
    public static AngularAccountResult doSave(Account account, String contactJSON, String deleteContactIdsJSON) {
        Savepoint sp = Database.setSavepoint();
        AngularAccountResult result = new AngularAccountResult();

        try {
            /*
            // 取引先のJSON文字列存在判定
            result = helper.isEmptyAccountJSON(accountJSON, result);
            // エラーがある場合は処理終了
            if (!result.errorMessages.isEmpty()) {
                return result;
            }
            */

            // 取引先責任者の削除
            if (String.isNotEmpty(deleteContactIdsJSON)) {
                // JSON → Map
                List<Object> jsonDelContactIdList = (List<Object>) JSON.deserializeUntyped(deleteContactIdsJSON);
                // 削除対象の取引先責任者ID取得
                Set<Id> delContactIds = helper.getDelContactIdsByJson(jsonDelContactIdList);
                // 削除対象の取引先責任者を取得
                List<Contact> deleteContacts = dao.getDeleteContacts(delContactIds);
                // 取引先責任者の削除
                delete deleteContacts;
            }
            /*
            // JSON → Map
            Map<String, Object> jsonAccountMap = (Map<String, Object>) JSON.deserializeUntyped(accountJSON);
            System.debug(jsonAccountMap);
            // 取引先取得
            Account account = helper.getAccountByJson(jsonAccountMap);
            */
            // 取引先値チェック
            result = helper.isAccountValidation(account, result);
            // エラーがある場合は処理終了
            if (!result.errorMessages.isEmpty()) {
                Database.rollback(sp);
                return result;
            }
            // 取引先登録
            upsert account;

            // 取引先責任者の登録
            if (String.isNotEmpty(contactJSON)) {
                // JSON → Map
                List<Object> jsonContactList = (List<Object>) JSON.deserializeUntyped(contactJSON);
                // 取引先責任者取得
                List<Contact> contacts = helper.getContactsByJson(account.Id, jsonContactList);
                // 取引先責任者値チェック
                result = helper.isContactValidation(contacts, result);
                // エラーがある場合は処理終了
                if (!result.errorMessages.isEmpty()) {
                    Database.rollback(sp);
                    return result;
                }
                // 取引先責任者登録
                upsert contacts;
            }
            
            // 取引先IDを返す
            result.accountId = account.Id;

        } catch(DmlException e) {
            Database.rollback(sp);
            result.errorMessages.add(e.getDmlMessage(0));
            return result;
        } catch(Exception e) {
            Database.rollback(sp);
            result.errorMessages.add(e.getMessage());
            return result;
        }

        return result;
    }
}