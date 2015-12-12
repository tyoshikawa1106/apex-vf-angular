public with sharing class AngularAccountResult {

    public Id accountId {get; set;}
    public List<String> errorMessages {get; set;}

    /**
     * コンストラクタ
     */
    public AngularAccountResult() {
        this.accountId = null;
        this.errorMessages = new List<String>();
    }
}