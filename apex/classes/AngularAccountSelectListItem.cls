public with sharing class AngularAccountSelectListItem {

    // LeadSource選択リスト値
    public Map<String, String> leadSourceMap {get; set;}

    /**
     * コンストラクタ
     */
    public AngularAccountSelectListItem() {
        // LeadSource選択リスト値
        this.leadSourceMap = new Map<String, String>();
    }

    /**
     * LeadSource選択リスト値取得
     */
    public Map<String, String> getLeadSourceMap() {
        Schema.DescribeFieldResult F = Contact.LeadSource.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        
        Map<String, String> optionMap = new Map<String, String>();
        optionMap.put('', '-- なし --');
        for (Schema.PicklistEntry pick : P) {
            optionMap.put(String.valueOf(pick.getValue()), String.valueOf(pick.getLabel()));
        }
        
        return optionMap;
    }
}