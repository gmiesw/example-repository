/**
 * Deal Payment Emails (Schedulable Class)
 * File Name: SCHD_DealPaymentEmails
 * 
 * @author Grant Miller (Euro Softworks)
 * @description Schedulable class which emails invoice requests to recepients if the Due Date is today, past due, or 7/14/21/30 days in the future, while "Invoice Request Sent Date" is not yet populated.
 * 
 * Schedule the Job to run at 9:00 AM every day using the following anonymous Apex:
 * 
 * String jobID = System.schedule('SCHD_DealPaymentEmails', '0 0 9 * * ?', new SCHD_DealPaymentEmails());
 * System.debug(jobID);
 */

global without sharing class SCHD_DealPaymentEmails implements Schedulable {
    /**
     * Execute Schedulable Apex
     */
    
    global void execute(SchedulableContext ctx) {
        /**
         * Relevant Payments
         */
        
        List<Payment__c> payments = [
            SELECT Id,
                   Name,
                   Deal__c,
                   Deal__r.Name,
                   Deal__r.OwnerId,
                   Deal__r.Owner.Name,
                   Deal__r.Owner.Email,
                   Deal__r.TTL_Core__Property__c,
                   Deal__r.TTL_Core__Property__r.Name,
                   Invoice_Request_Sent_date__c,
                   Due_Date__c,
                   Due_Date_Formula__c
              FROM Payment__c
             WHERE Deal__c != null
               AND Invoice_Request_Sent_date__c = null
               AND Due_Date__c != null
               // AND DAY_ONLY(CreatedDate) >= 2020-02-24
        ];
        
        /**
         * Send Emails (if necessary)
         */
        
        if (payments.size() > 0) {
            Boolean isProduction = ![
                SELECT IsSandbox
                  FROM Organization
                 LIMIT 1
            ].IsSandbox;
            
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            
            String currentUserFullName = UserInfo.getName();
            String currentUserEmailAddress = UserInfo.getUserEmail();
            
            Date today = Date.today();
            
            for (Payment__c payment : payments) {
                Boolean isTimeForEmailNotification = today >= payment.Due_Date__c // Due Date is today or past due
                    || today.addDays(7) == payment.Due_Date__c // Due Date is 7 days in future
                    || today.addDays(14) == payment.Due_Date__c // Due Date is 14 days in future
                    || today.addDays(21) == payment.Due_Date__c // Due Date is 21 days in future
                    || today.addDays(30) == payment.Due_Date__c; // Due Date is 30 days in future
                
                if (isTimeForEmailNotification) {
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    
                    String paymentURL = '';
                    
                    if (isProduction) {
                        paymentURL = 'https://rethink-8893.lightning.force.com/lightning/r/Payment__c/' + payment.Id + '/view';
                    } else {
                        paymentURL = 'https://rethink-8893--eswjan20.lightning.force.com/lightning/r/Payment__c/' + payment.Id + '/view';
                    }
                    
                    List<String> toAddresses = new List<String>();
                    List<String> ccAddresses = new List<String>();
                    
                    toAddresses.add(payment.Deal__r.Owner.Email);
                    
                    ccAddresses.add('jason@piersonre.com');
                    ccAddresses.add('amy@piersonre.com');
                    
                    message.setToAddresses(toAddresses);
                    message.setCcAddresses(ccAddresses);
                    
                    message.setSenderDisplayName(currentUserFullName);
                    message.setReplyTo(currentUserEmailAddress);
                    
                    message.setUseSignature(false);
                    message.setBccSender(false);
                    message.setSaveAsActivity(false);
                    
                    message.setSubject('Payment Due Date Notification: "' + payment.Name + '"');
                    message.setHtmlBody(payment.Deal__r.Owner.Name + ',<br><br>This notice is to inform you that the due date for ' + payment.Name + ' is due on ' + payment.Due_Date__c + '.<br><br>Please click on the attached link to submit for invoicing: <a href="' + paymentURL + '">' + paymentURL + '</a>');
                    // message.setPlainTextBody(payment.Deal__r.Owner.Name + ',\n\nThis notice is to inform you that the due date for ' + payment.Name + ' is due on ' + payment.Due_Date__c + '.\n\nPlease click on the attached link to submit for invoicing: ' + paymentURL);
                    
                    messages.add(message);
                }
            }
            
            /**
             * Send Emails and Log Results
             */
            
            if (messages.size() > 0) {
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(messages);
                
                for (Messaging.SendEmailResult result : results) {
                    if (result.success) {
                        System.debug('The email was sent successfully.');
                    } else {
                        System.debug('The email failed to send: ' + result.errors[0].message);
                    }
                }
            }
        }
    }
}