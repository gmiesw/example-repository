/**
 * Deals Submitted and Pending Approval (Test Class)
 * File Name: TEST_DealsWaitingSubmittal
 * 
 * @author Grant Miller (Euro Softworks)
 * @description Test class for the controller for DealsWaitingSubmittal which displays a table for "Deals Waiting for Submittal".
 */

@isTest
private class TEST_DealsWaitingSubmittal {
    @isTest
    static void test() {
        TTL_Core__Deal__c deal = new TTL_Core__Deal__c(
            Name = 'Example Deal'
        );
        
        insert deal;
        
        PageReference dealsPendingApproval = Page.DealsWaitingSubmittal;
        
        Test.setCurrentPage(dealsPendingApproval);
        dealsPendingApproval.getParameters().put('Id', String.valueOf(deal.Id));
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(deal);
        CTRL_DealsWaitingSubmittal controller = new CTRL_DealsWaitingSubmittal(standardController);
    }
}