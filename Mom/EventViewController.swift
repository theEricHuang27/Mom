//
//  EventViewController.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 2/19/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var SubjectTextField: UITextField!
    @IBOutlet var DatePicker: UIDatePicker!
    @IBOutlet var InformationTextField: UITextField!
    @IBOutlet var CreateEventButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        SubjectTextField.delegate = self
        InformationTextField.delegate = self
        SubjectTextField.becomeFirstResponder()
    }
    @IBAction func CreateEvent(_ sender: UIButton) {
        guard let subject = SubjectTextField.text else {return}
        let date = DatePicker.date
        guard let information = InformationTextField.text else {return}
        let event = Event(date: date, subject: subject, information: information)
        event.toString()
        _ = navigationController?.popViewController(animated: true)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let event = Event(date: date, subject: subject, information: information)
//        NextViewController
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if SubjectTextField.isFirstResponder {
            InformationTextField.becomeFirstResponder()
        }
        else {
            InformationTextField.resignFirstResponder()
            CreateEventButton.isEnabled = true
        }
        return true
    }
}
