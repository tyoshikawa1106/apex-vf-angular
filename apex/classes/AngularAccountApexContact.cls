public with sharing class AngularAccountApexContact {

    public Contact contact {get; set;}
    public Boolean isChanged {get; set;}

    /**
     * コンストラクタ
     */
    public AngularAccountApexContact() {
        this.contact = new Contact();
        this.isChanged = false;
    }
}