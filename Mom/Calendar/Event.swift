//
//  Event.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 2/5/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding{
    // Vars
    var d: Date
    var subject: String
    var information: String
    
    // Init's
    override init(){
        d = Date()
        subject = ""
        information = ""
    }
    init(d: Date, subject: String, information: String){
        self.d = d
        self.subject = subject
        self.information = information
    }
    // NSCoding Compliance
    func encode(with coder: NSCoder) {
        coder.encode(d, forKey: "d")
        coder.encode(subject, forKey: "subject")
        coder.encode(information, forKey: "information")
    }
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.d = decoder.decodeObject(forKey: "d") as! Date
        self.subject = decoder.decodeObject(forKey: "subject") as! String
        self.information = decoder.decodeObject(forKey: "information") as! String
    }
}
