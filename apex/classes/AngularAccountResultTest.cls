@isTest
private class AngularAccountResultTest {

    private static User testAdminUser = AngularAccountTester.getLoginUser();

    /**
     * コンストラクタ
     */
    static testMethod void AngularAccountResultTest1() {

        System.runAs(testAdminUser) {

            Test.startTest();

            AngularAccountResult cls = new AngularAccountResult();

            Test.stopTest();

            System.assertEquals(String.isEmpty(cls.accountId), true);
            System.assertEquals(cls.errorMessages.isEmpty(), true);
        }
    }
}