//
//  blackboardJSON.swift
//  bruh
//
//  Created by Chang-Chi Huang (student LM) on 3/6/19.
//  Copyright © 2019 Chang-Chi Huang (student LM). All rights reserved.
//

import Foundation

struct blackboardResponse: Decodable {
    let results: [result]
}

struct result: Decodable {
    let type: String
    let calendarName: String
    let title: String?
    let description: String?
    let start : String?
    let end : String?
    let color : String
}


