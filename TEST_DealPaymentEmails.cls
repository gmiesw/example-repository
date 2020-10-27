/**
 * Test Deal Payment Emails (Test Class)
 * File Name: TEST_DealPaymentEmails
 * 
 * @author Grant Miller (Euro Softworks)
 * @description Test class for SCHD_DealPaymentEmails which emails invoice requests to recepients if the Due Date is today, past due, or 7/14/21/30 days in the future, while "Invoice Request Sent Date" is not yet populated.
 */

@isTest(seeAllData='true')
private class TEST_DealPaymentEmails {
    @isTest
    static void test() {
        TTL_Core__Property__c property = new TTL_Core__Property__c(
            Name = 'Example Property'
        );
        
        insert property;
        
        TTL_Core__Deal__c deal = new TTL_Core__Deal__c(
            Name = 'Example Deal',
            TTL_Core__Property__c = property.Id
        );
        
        insert deal;
        
        Payment__c payment = new Payment__c(
            Name = 'Example Payment',
            Deal__c = deal.Id,
            Due_Date__c = Date.valueOf('2020-03-25'),
            Payment_Option__c = 100
        );
        
        insert payment;
        
        String jobId = System.schedule('SCHD_DealPaymentEmails', '0 0 0 15 3 ? 2022', new SCHD_DealPaymentEmails());
    }
}