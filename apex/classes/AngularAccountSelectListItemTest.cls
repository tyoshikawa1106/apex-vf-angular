@isTest
private class AngularAccountSelectListItemTest {

    private static User testAdminUser = AngularAccountTester.getLoginUser();

    /**
     * コンストラクタ
     */
    static testMethod void AngularAccountSelectListItemTest1() {

        System.runAs(testAdminUser) {

            Test.startTest();

            AngularAccountSelectListItem cls = new AngularAccountSelectListItem();

            Test.stopTest();

            System.assertEquals(cls.leadSourceMap.isEmpty(), true);
        }
    }

    /**
     * LeadSource選択リスト値取得
     */
    static testMethod void getLeadSourceMapTest1() {

        System.runAs(testAdminUser) {

            Test.startTest();

            AngularAccountSelectListItem cls = new AngularAccountSelectListItem();
            cls.leadSourceMap = cls.getLeadSourceMap();

            Test.stopTest();

            System.assertEquals(cls.leadSourceMap.isEmpty(), false);
        }
    }
}