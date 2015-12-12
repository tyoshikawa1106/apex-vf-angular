@isTest
private class AngularAccountControllerTest {

    private static User testAdminUser = AngularAccountTester.getLoginUser();

    /**
     * コンストラクタ
     * 値なし
     */
    static testMethod void AngularAccountControllerTest1() {

        System.runAs(testAdminUser) {

            Test.startTest();

            AngularAccountController cls = new AngularAccountController(new ApexPages.StandardController(new Account()));

            Test.stopTest();

            System.assertEquals(String.isEmpty(cls.account.Id), true);
        }
    }

    /**
     * コンストラクタ
     * 値あり
     */
    static testMethod void AngularAccountControllerTest2() {

        System.runAs(testAdminUser) {

            Account account = AngularAccountTester.createAccount(true);

            Test.startTest();

            AngularAccountController cls = new AngularAccountController(new ApexPages.StandardController(account));

            Test.stopTest();

            System.assertEquals(String.isNotEmpty(cls.account.Id), true);
        }
    }

    /**
     * 取引先責任者取得
     * 値なし
     */
    static testMethod void getContactsTest1() {

        System.runAs(testAdminUser) {

            String accountId = '';

            Test.startTest();

            List<Contact> results = AngularAccountController.getContacts(accountId);

            Test.stopTest();

            System.assertEquals(results.isEmpty(), true);
        }
    }

    /**
     * 取引先責任者取得
     * 値あり
     */
    static testMethod void getContactsTest2() {

        System.runAs(testAdminUser) {

            Account account = AngularAccountTester.createAccount(true);
            Contact contact = AngularAccountTester.createContact(account, true);

            String accountId = account.Id;

            Test.startTest();

            List<Contact> results = AngularAccountController.getContacts(accountId);

            Test.stopTest();

            System.assertEquals(results.size(), 1);
        }
    }

    /**
     * 選択リスト値取得
     */
    static testMethod void getAngularAccountSelectListItemTest1() {

        System.runAs(testAdminUser) {

            String accountId = '';

            Test.startTest();

            AngularAccountSelectListItem result = AngularAccountController.getAngularAccountSelectListItem();

            Test.stopTest();

            System.assertEquals(result.leadSourceMap.isEmpty(), false);
        }
    }

    /**
     * 保存ボタン処理
     * 値なし
     */
    static testMethod void doSaveTest1() {

        System.runAs(testAdminUser) {

            Account account = new Account();
            String contactJSON = '';
            String deleteContactIdsJSON = '';

            Test.startTest();

            AngularAccountResult result = AngularAccountController.doSave(account, contactJSON, deleteContactIdsJSON);

            Test.stopTest();

            System.assertEquals(result.errorMessages.size(), 1);
        }
    }

    /**
     * 保存ボタン処理
     * 取引先保存
     */
    static testMethod void doSaveTest2() {

        System.runAs(testAdminUser) {

            // 取引先テストデータ
            Account account = AngularAccountTester.createAccount(false);

            String contactJSON = '';
            String deleteContactIdsJSON = '';

            Test.startTest();

            AngularAccountResult result = AngularAccountController.doSave(account, contactJSON, deleteContactIdsJSON);

            Test.stopTest();

            System.assertEquals(String.isNotEmpty(result.accountId), true);
            System.assertEquals(result.errorMessages.isEmpty(), true);
        }
    }

    /**
     * 保存ボタン処理
     * 取引先必須エラー
     */
    static testMethod void doSaveTest3() {

        System.runAs(testAdminUser) {

            // 取引先テストデータ
            Account account = AngularAccountTester.createAccount(false);
            account.Name = '';

            String contactJSON = '';
            String deleteContactIdsJSON = '';

            Test.startTest();

            AngularAccountResult result = AngularAccountController.doSave(account, contactJSON, deleteContactIdsJSON);

            Test.stopTest();

            System.assertEquals(String.isEmpty(result.accountId), true);
            System.assertEquals(result.errorMessages.isEmpty(), false);
        }
    }

    /**
     * 保存ボタン処理
     * 取引先責任者保存
     */
    static testMethod void doSaveTest5() {

        System.runAs(testAdminUser) {

            // 取引先テストデータ
            Account account = AngularAccountTester.createAccount(false);

            // JSON文字列の生成
            JSONGenerator conGen = JSON.createGenerator(true);
            conGen.writeStartObject();
            conGen.writeBooleanField('IsChanged', false);
            conGen.writeStringField('Id', '');
            conGen.writeStringField('LastName', 'Salesforce');
            conGen.writeStringField('FirstName', 'Saasy');
            conGen.writeEndObject();
            String contactJSON  = '[' + conGen.getAsString() + ']';
            String deleteContactIdsJSON = '';

            Test.startTest();

            AngularAccountResult result = AngularAccountController.doSave(account, contactJSON, deleteContactIdsJSON);

            Test.stopTest();

            System.assertEquals(String.isNotEmpty(result.accountId), true);
            System.assertEquals(result.errorMessages.isEmpty(), true);
            // 取引先責任者の取得
            Integer resultContactCount = [SELECT COUNT() FROM Contact WHERE AccountId =: result.accountId LIMIT 200];
            System.assertEquals(resultContactCount, 1);
        }
    }

    /**
     * 保存ボタン処理
     * 取引先責任者保存必須エラー
     */
    static testMethod void doSaveTest6() {

        System.runAs(testAdminUser) {

            // 取引先テストデータ
            Account account = AngularAccountTester.createAccount(false);

            // JSON文字列の生成
            JSONGenerator conGen = JSON.createGenerator(true);
            conGen.writeStartObject();
            conGen.writeBooleanField('IsChanged', false);
            conGen.writeStringField('Id', '');
            conGen.writeStringField('LastName', '');
            conGen.writeStringField('FirstName', 'Saasy');
            conGen.writeEndObject();
            String contactJSON  = '[' + conGen.getAsString() + ']';
            String deleteContactIdsJSON = '';

            Test.startTest();

            AngularAccountResult result = AngularAccountController.doSave(account, contactJSON, deleteContactIdsJSON);

            Test.stopTest();

            System.assertEquals(String.isEmpty(result.accountId), true);
            System.assertEquals(result.errorMessages.isEmpty(), false);
            // 取引先責任者の取得
            Integer resultContactCount = [SELECT COUNT() FROM Contact LIMIT 200];
            System.assertEquals(resultContactCount, 0);
        }
    }

    /**
     * 保存ボタン処理
     * 取引先責任者削除
     */
    static testMethod void doSaveTest7() {

        System.runAs(testAdminUser) {

            // 取引先テストデータ
            Account account = AngularAccountTester.createAccount(true);
            // 取引先責任者JSON文字列
            String contactJSON  = '';
            // 取引先責任者情報作成
            Contact contact = AngularAccountTester.createContact(account, true);
            String deleteContactIdsJSON = '[' + '\"' + contact.Id + '\"' + ']';

            Test.startTest();

            AngularAccountResult result = AngularAccountController.doSave(account, contactJSON, deleteContactIdsJSON);

            Test.stopTest();

            System.assertEquals(String.isNotEmpty(result.accountId), true);
            System.assertEquals(result.errorMessages.isEmpty(), true);
            // 取引先責任者の取得
            Integer resultContactCount = [SELECT COUNT() FROM Contact WHERE AccountId =: result.accountId LIMIT 200];
            System.assertEquals(resultContactCount, 0);
        }
    }
}