//
//  DescriptionViewController.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 4/9/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet var Subject: UILabel!
    @IBOutlet var Day: UILabel!
    @IBOutlet var Description: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Subject.text = subj
        Day.text = "\(dateString) @ \(time)"
        let htmlString = desc
        let htmlData = NSString(string: htmlString).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        Description.attributedText = attributedString
    }
}
