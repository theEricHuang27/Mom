//
//  DescriptionViewController.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 4/9/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController, ThemedViewController {
    
    var backView: UIView { return self.view }
    var navBar: UINavigationBar { return self.navigationController!.navigationBar }
    var labels: [UILabel]? {
        return [Subject, Day]
    }
    var buttons: [UIButton]? { return nil }
    var textFields: [UITextField]? { return nil }
    func theme(isDarkTheme: Bool) {
        defaultTheme(isDarkTheme: isDarkTheme)
        if isDarkTheme {
            Description.textColor = UIColor.white
            Description.backgroundColor = UIColor.myDeepGrey
        } else {
            Description.textColor = UIColor.black
            Description.backgroundColor = UIColor.white
        }
    }
    

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        theme(isDarkTheme: SettingsViewController.isDarkTheme)
    }
}
