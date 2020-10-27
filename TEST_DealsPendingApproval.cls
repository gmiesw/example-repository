/**
 * Deals Submitted and Pending Approval (Test Class)
 * File Name: TEST_DealsPendingApproval
 * 
 * @author Grant Miller (Euro Softworks)
 * @description Test class for the controller for DealsPendingApproval which displays a table for "Deals Submitted and Pending Approval".
 */

@isTest
private class TEST_DealsPendingApproval {
    @isTest
    static void test() {
        TTL_Core__Deal__c deal = new TTL_Core__Deal__c(
            Name = 'Example Deal'
        );
        
        insert deal;
        
        PageReference dealsPendingApproval = Page.DealsPendingApproval;
        
        Test.setCurrentPage(dealsPendingApproval);
        dealsPendingApproval.getParameters().put('Id', String.valueOf(deal.Id));
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(deal);
        CTRL_DealsPendingApproval controller = new CTRL_DealsPendingApproval(standardController);
    }
}