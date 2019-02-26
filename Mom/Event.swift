//
//  Event.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 2/5/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import Foundation

class Event: NSObject {
    // Vars
    var date: Date
    var subject: String
    var information: String
    
    // Init's
    override init(){
        date = Date()
        subject = ""
        information = ""
    }
    init(date: Date, subject: String, information: String){
        self.date = date
        self.subject = subject
        self.information = information
    }
    func toString(){
        print("Date: \(date)")
    }
}
