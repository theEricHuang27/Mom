//
//  Course.swift
//  Mom
//
//  Created by Aidan Barr Bono (student LM) on 2/11/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import Foundation

class Course {
    
    var teacher : String
    var subject : String
    var letterGrade : String
    var grade : Int
    
    init() {
        teacher = ""
        subject = ""
        letterGrade = ""
        grade = 0
    }
    
    init(teacher : String, subject : String, letterGrade : String, grade : Int) {
        self.teacher = teacher
        self.subject = subject
        self.letterGrade = letterGrade
        self.grade = grade
    }
    
}
