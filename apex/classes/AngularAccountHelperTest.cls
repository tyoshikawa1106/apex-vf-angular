@isTest
private class AngularAccountHelperTest {

    private static AngularAccountHelper helper = new AngularAccountHelper();
    private static User testAdminUser = AngularAccountTester.getLoginUser();

    /**
     * 取引先のJSON文字列存在判定
     * 値なし
     */
    static testMethod void isEmptyAccountJSONTest1() {
        
        System.runAs(testAdminUser) {

            String accountJSON = '';
            AngularAccountResult result = new AngularAccountResult();

            Test.startTest();
            
            result = helper.isEmptyAccountJSON(accountJSON, result);
            
            Test.stopTest();

            System.assertEquals(result.errorMessages.isEmpty(), false);
        }
    }

    /**
     * 取引先のJSON文字列存在判定
     * 値あり
     */
    static testMethod void isEmptyAccountJSONTest2() {
        
        System.runAs(testAdminUser) {

            String accountJSON = 'Test String';
            AngularAccountResult result = new AngularAccountResult();

            Test.startTest();
            
            result = helper.isEmptyAccountJSON(accountJSON, result);
            
            Test.stopTest();

            System.assertEquals(result.errorMessages.isEmpty(), true);
        }
    }

    /**
     * 削除対象取引先責任者ID取得
     * テストデータなし
     */
    static testMethod void getDelContactIdsByJsonTest1() {
        
        System.runAs(testAdminUser) {

            List<Object> jsonDelContactIdList = new List<Object>();

            Test.startTest();
            
            Set<Id> results = helper.getDelContactIdsByJson(jsonDelContactIdList);
            
            Test.stopTest();

            System.assertEquals(results.isEmpty(), true);
        }
    }

    /**
     * 削除対象取引先責任者ID取得
     * テストデータあり
     */
    static testMethod void getDelContactIdsByJsonTest2() {
        
        System.runAs(testAdminUser) {

            Account account = AngularAccountTester.createAccount(true);
            Contact contact = AngularAccountTester.createContact(account, true);

            // JSON文字列の生成
            String deleteContactIdJSON = '[' + '\"' + contact.Id + '\"' + ']';
            List<Object> jsonDelContactIdList = (List<Object>) JSON.deserializeUntyped(deleteContactIdJSON);

            Test.startTest();
            
            Set<Id> results = helper.getDelContactIdsByJson(jsonDelContactIdList);
            
            Test.stopTest();

            System.assertEquals(results.size(), 1);
        }
    }

    /**
     * 取引先取得
     * テストデータなし
     */
    static testMethod void getAccountByJsonTest1() {
        
        System.runAs(testAdminUser) {

            Map<String, Object> jsonMap = new Map<String, Object>();

            Test.startTest();
            
            Account result = helper.getAccountByJson(jsonMap);
            
            Test.stopTest();

            System.assertEquals(String.isEmpty(result.Id), true);
            System.assertEquals(String.isEmpty(result.Name), true);
            System.assertEquals(String.isEmpty(result.AccountNumber), true);
        }
    }

    /**
     * 取引先取得
     * テストデータなし
     */
    static testMethod void getAccountByJsonTest2() {
        
        System.runAs(testAdminUser) {

            // JSON文字列の生成
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('Id', '');
            gen.writeStringField('Name', '');
            gen.writeStringField('AccountNumber', '');
            gen.writeEndObject();
            String accountJSON = gen.getAsString();

            Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(accountJSON);

            Test.startTest();
            
            Account result = helper.getAccountByJson(jsonMap);
            
            Test.stopTest();

            System.assertEquals(String.isEmpty(result.Id), true);
            System.assertEquals(String.isEmpty(result.Name), true);
            System.assertEquals(String.isEmpty(result.AccountNumber), true);
        }
    }

    /**
     * 取引先取得
     * テストデータあり
     */
    static testMethod void getAccountByJsonTest3() {
        
        System.runAs(testAdminUser) {

            Account account = AngularAccountTester.createAccount(true);

            // JSON文字列の生成
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeIdField('Id', account.Id);
            gen.writeStringField('Name', account.Name);
            gen.writeStringField('AccountNumber', account.AccountNumber);
            gen.writeEndObject();
            String accountJSON = gen.getAsString();

            Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(accountJSON);

            Test.startTest();
            
            Account result = helper.getAccountByJson(jsonMap);
            
            Test.stopTest();

            // 存在チェック
            System.assertEquals(String.isNotEmpty(result.Id), true);
            System.assertEquals(String.isNotEmpty(result.Name), true);
            System.assertEquals(String.isNotEmpty(result.AccountNumber), true);
            // 値チェック
            System.assertEquals(result.Id, account.Id);
            System.assertEquals(result.Name, account.Name);
            System.assertEquals(result.AccountNumber, account.AccountNumber);
        }
    }

    /**
     * 取引先値判定
     * テストデータなし
     */
    static testMethod void isAccountValidationTest1() {
        
        System.runAs(testAdminUser) {

            Account account = new Account();
            AngularAccountResult result = new AngularAccountResult();

            Test.startTest();
            
            result = helper.isAccountValidation(account, result);
            
            Test.stopTest();

            System.assertEquals(result.errorMessages.isEmpty(), false);
        }
    }

    /**
     * 取引先値判定
     * テストデータあり
     */
    static testMethod void isAccountValidationTest2() {
        
        System.runAs(testAdminUser) {

            Account account = AngularAccountTester.createAccount(true);
            AngularAccountResult result = new AngularAccountResult();

            Test.startTest();
            
            result = helper.isAccountValidation(account, result);
            
            Test.stopTest();

            System.assertEquals(result.errorMessages.isEmpty(), true);
        }
    }

    /**
     * 取引先責任者取得
     * テストデータなし
     */
    static testMethod void getContactsByJsonTest1() {
        
        System.runAs(testAdminUser) {

            Id accountId = null;
            List<Object> jsonContactList = new List<Object>();

            Test.startTest();
            
            List<Contact> results = helper.getContactsByJson(accountId, jsonContactList);
            
            Test.stopTest();

            System.assertEquals(results.isEmpty(), true);
        }
    }

    /**
     * 取引先責任者取得
     * テストデータなし
     */
    static testMethod void getContactsByJsonTest2() {
        
        System.runAs(testAdminUser) {

            // JSON文字列の生成
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeBooleanField('IsChanged', false);
            gen.writeStringField('Id', '');
            gen.writeStringField('LastName', '');
            gen.writeStringField('FirstName', '');
            gen.writeEndObject();
            String contactJSON  = '[' + gen.getAsString() + ']';

            // 引数
            Id accountId = null;
            List<Object> jsonContactList = (List<Object>) JSON.deserializeUntyped(contactJSON);

            Test.startTest();
            
            List<Contact> results = helper.getContactsByJson(accountId, jsonContactList);
            
            Test.stopTest();

            System.assertEquals(results.size(), 1);
            System.assertEquals(String.isEmpty(results[0].Id), true);
            System.assertEquals(String.isEmpty(results[0].LastName), true);
            System.assertEquals(String.isEmpty(results[0].FirstName), true);
        }
    }

    /**
     * 取引先責任者取得
     * テストデータあり
     */
    static testMethod void getContactsByJsonTest3() {
        
        System.runAs(testAdminUser) {

            Account account = AngularAccountTester.createAccount(true);
            Contact contact = AngularAccountTester.createContact(account, true);

            // JSON文字列の生成
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeBooleanField('IsChanged', true);
            gen.writeIdField('Id', contact.Id);
            gen.writeStringField('LastName', contact.LastName);
            gen.writeStringField('FirstName', contact.FirstName);
            gen.writeStringField('LeadSource', contact.LeadSource);
            gen.writeStringField('Description', contact.Description);
            gen.writeEndObject();
            String contactJSON  = '[' + gen.getAsString() + ']';

            // 引数
            Id accountId = null;
            List<Object> jsonContactList = (List<Object>) JSON.deserializeUntyped(contactJSON);

            Test.startTest();
            
            List<Contact> results = helper.getContactsByJson(accountId, jsonContactList);
            
            Test.stopTest();

            System.assertEquals(results.size(), 1);
            System.assertEquals(String.isNotEmpty(results[0].Id), true);
            System.assertEquals(String.isNotEmpty(results[0].LastName), true);
            System.assertEquals(String.isNotEmpty(results[0].FirstName), true);
            System.assertEquals(String.isNotEmpty(results[0].LeadSource), true);
            System.assertEquals(String.isNotEmpty(results[0].Description), true);
        }
    }

    /**
     * 取引先責任者取得
     * テストデータあり
     */
    static testMethod void getContactsByJsonTest4() {
        
        System.runAs(testAdminUser) {

            Account account = AngularAccountTester.createAccount(true);
            Contact contact = AngularAccountTester.createContact(account, true);

            // JSON文字列の生成
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeBooleanField('IsChanged', false);
            gen.writeIdField('Id', contact.Id);
            gen.writeStringField('LastName', contact.LastName);
            gen.writeStringField('FirstName', contact.FirstName);
            gen.writeEndObject();
            String contactJSON  = '[' + gen.getAsString() + ']';

            // 引数
            Id accountId = null;
            List<Object> jsonContactList = (List<Object>) JSON.deserializeUntyped(contactJSON);

            Test.startTest();
            
            List<Contact> results = helper.getContactsByJson(accountId, jsonContactList);
            
            Test.stopTest();

            System.assertEquals(results.size(), 0);
        }
    }

    /**
     * 取引先責任者値判定
     * テストデータなし
     */
    static testMethod void isContactValidationTest1() {
        
        System.runAs(testAdminUser) {

            List<Contact> contacts = new List<Contact>();
            AngularAccountResult result = new AngularAccountResult();

            Test.startTest();
            
            result = helper.isContactValidation(contacts, result);
            
            Test.stopTest();

            System.assertEquals(result.errorMessages.size(), 0);
        }
    }
    /**
     * 取引先責任者値判定
     * テストデータなし
     */
    static testMethod void isContactValidationTest2() {
        
        System.runAs(testAdminUser) {

            List<Contact> contacts = new List<Contact>();
            contacts.add(new Contact());
            AngularAccountResult result = new AngularAccountResult();

            Test.startTest();
            
            result = helper.isContactValidation(contacts, result);
            
            Test.stopTest();

            System.assertEquals(result.errorMessages.size(), 2);
        }
    }

    /**
     * 取引先責任者値判定
     * テストデータあり
     */
    static testMethod void isContactValidationTest3() {
        
        System.runAs(testAdminUser) {

            Account account = AngularAccountTester.createAccount(true);
            Contact contact = AngularAccountTester.createContact(account, true);

            List<Contact> contacts = new List<Contact>{contact};
            AngularAccountResult result = new AngularAccountResult();

            Test.startTest();
            
            result = helper.isContactValidation(contacts, result);
            
            Test.stopTest();

            System.assertEquals(result.errorMessages.size(), 0);
        }
    }
}