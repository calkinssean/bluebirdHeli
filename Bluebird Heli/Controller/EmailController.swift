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
    
    func testEmail() {
        
        let mailgun = MailgunAPI(apiKey: "YouAPIKey", clientDomain: "yourDomain.com")
        
        mailgun.sendEmail(to: "[email protected]", from: "Test User <[email protected]>", subject: "This is a test", bodyHTML: "<b>test<b>") { mailgunResult in
            
            if mailgunResult.success{
                print("Email was sent")
            }
            
        }
    }
}
