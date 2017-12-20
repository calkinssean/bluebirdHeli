//
//  EmailController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 12/13/17.
//  Copyright © 2017 Sean Calkins. All rights reserved.
//

import Foundation
import SwiftMailgun

class EmailController {
    
    fileprivate let apiKey = "key-7b2178e5eb8bfc7701e2b026df06e554"
    fileprivate let recipient = "calkins.sean@gmail.com"
    fileprivate let domain = "www.test.com"
    
    func sendEmail() {
        
        let mailgun = MailgunAPI(apiKey: apiKey, clientDomain: domain)
        
        mailgun.sendEmail(to: recipient, from: "Blue Bird Heli App", subject: "This is a test", bodyHTML: "<b>test<b>") { mailgunResult in
            if mailgunResult.success{
                print("Email was sent")
            } else {
                print("Mail not sent :(")
            }
        }
            
    }
    
}
