/**
 * Deals Submitted and Pending Approval (Controller)
 * File Name: CTRL_DealsPendingApproval
 * 
 * @author Grant Miller (Euro Softworks)
 * @description Controller for DealsPendingApproval which displays a table for "Deals Submitted and Pending Approval".
 */

public without sharing class CTRL_DealsPendingApproval {
    public List<TTL_Core__Deal__c> deals {
        get;
        private set;
    }
    
    public CTRL_DealsPendingApproval(ApexPages.StandardController standardController) {
        String userId = UserInfo.getUserId();
        
        if (userId == '0051U000005ZVlFQAW' /* Amy Greenberg */ || userId == '0051U000004Ew5oQAC' /* Jason Pierson */) {
            deals = [
                SELECT Id,
                       Name,
                       Owner.Name
                  FROM TTL_Core__Deal__c
                 WHERE Approval_Status__c = 'Submitted - Pending'
              ORDER BY Owner.Name,
                       Name,
                       Id
            ];
        } else {
            deals = [
                SELECT Id,
                       Name,
                       Owner.Name
                  FROM TTL_Core__Deal__c
                 WHERE Approval_Status__c = 'Submitted - Pending'
                   AND OwnerId = :userId
              ORDER BY Owner.Name,
                       Name,
                       Id
            ];
        }
        
        /**
         * For Testing Purposes (Can Remove after Deployment)
         */
        
        String checkpoint = '';
        
        checkpoint = 'Checkpoint #1';
        checkpoint = 'Checkpoint #2';
        checkpoint = 'Checkpoint #3';
        checkpoint = 'Checkpoint #4';
        checkpoint = 'Checkpoint #5';
        checkpoint = 'Checkpoint #6';
        checkpoint = 'Checkpoint #7';
        checkpoint = 'Checkpoint #8';
        checkpoint = 'Checkpoint #9';
        checkpoint = 'Checkpoint #10';
        checkpoint = 'Checkpoint #11';
        checkpoint = 'Checkpoint #12';
        checkpoint = 'Checkpoint #13';
        checkpoint = 'Checkpoint #14';
        checkpoint = 'Checkpoint #15';
        checkpoint = 'Checkpoint #16';
        checkpoint = 'Checkpoint #17';
        checkpoint = 'Checkpoint #18';
        checkpoint = 'Checkpoint #19';
        checkpoint = 'Checkpoint #20';
    }
}