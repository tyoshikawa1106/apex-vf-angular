@isTest
private class AngularAccountDaoTest {

    private static AngularAccountDao dao = new AngularAccountDao();
    private static User testAdminUser = AngularAccountTester.getLoginUser();

    /**
     * 取引先に紐付く取引先責任者を取得
     * テストデータなし
     */
    static testMethod void getAccountsTest1() {
        
        System.runAs(testAdminUser) {

            String accountId = '';

            Test.startTest();
            
            List<Contact> results = dao.getContacts(accountId);
            
            Test.stopTest();

            System.assertEquals(results.isEmpty(), true);
        }
    }

    /**
     * 取引先に紐付く取引先責任者を取得
     * テストデータあり
     */
    static testMethod void getAccountsTest2() {
        
        System.runAs(testAdminUser) {

            Account account = AngularAccountTester.createAccount(true);
            Contact contact = AngularAccountTester.createContact(account, true);

            String accountId = account.Id;

            Test.startTest();
            
            List<Contact> results = dao.getContacts(accountId);
            
            Test.stopTest();

            System.assertEquals(results.size(), 1);
        }
    }

    /**
     * 削除対象の取引先責任者を取得
     * テストデータなし
     */
    static testMethod void getDeleteContactsTest1() {
        
        System.runAs(testAdminUser) {

            Set<Id> contactIds = new Set<Id>();

            Test.startTest();
            
            List<Contact> results = dao.getDeleteContacts(contactIds);
            
            Test.stopTest();

            System.assertEquals(results.isEmpty(), true);
        }
    }

    /**
     * 削除対象の取引先責任者を取得
     * テストデータあり
     */
    static testMethod void getDeleteContactsTest2() {
        
        System.runAs(testAdminUser) {

            Account account = AngularAccountTester.createAccount(true);
            Contact contact = AngularAccountTester.createContact(account, true);

            Set<Id> contactIds = new Set<Id>{contact.Id};

            Test.startTest();
            
            List<Contact> results = dao.getDeleteContacts(contactIds);
            
            Test.stopTest();

            System.assertEquals(results.size(), 1);
        }
    }
}