@isTest
private class AngularAccountApexContactTest {

    private static User testAdminUser = AngularAccountTester.getLoginUser();

    /**
     * コンストラクタ
     */
    static testMethod void AngularAccountApexContactTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            AngularAccountApexContact cls = new AngularAccountApexContact();
            
            Test.stopTest();

            System.assertEquals(String.isEmpty(cls.contact.Id), true);
            System.assertEquals(cls.isChanged, false);
        }
    }
}