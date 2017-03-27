//
//  LogInViewController.swift
//  TestTaskApp
//
//  Created by Petar Santor on 3/27/17.
//  Copyright © 2017 Petar Santor. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {

    
    //MARK: - Outlets
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonLogIn: UIButton!
    
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp(textField: self.textFieldEmail)
        self.setUp(textField: self.textFieldPassword)
        
        self.buttonLogIn.setTitle("Log In", for: .normal)
        self.buttonLogIn.titleLabel?.font = UIFont(name: Constants.Font.RobotoMedium, size: 18)
        self.buttonLogIn.setTitleColor(UIColor.red, for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.dismissKeyboard(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Utilities
    
    
    func setUp(textField field:UITextField?) {
        field?.delegate = self

        field?.autocorrectionType = .no
        field?.spellCheckingType = .no
        
        if (field == self.textFieldEmail) {
            field?.returnKeyType = .next
            field?.keyboardType = .emailAddress
            field?.tag = 1
        } else {
            field?.returnKeyType = .go
            field?.isSecureTextEntry = true
            field?.tag = 2
        }
    }
    
    func dismissKeyboard(gesture: UITapGestureRecognizer) {
        self.textFieldEmail.resignFirstResponder()
        self.textFieldPassword.resignFirstResponder()
    }
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
    }
    
    
    //MARK: - Notifications
    
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + 20, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.textFieldPassword {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height - 20, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
   
    
    //MARK: - UITextField delegate methods
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTage = textField.tag + 1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil) {
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
            self.handleTapOnLogInButton(Any.self)
        }
        return false
    }
    
    
    //MARK: - Actions
    
    
    @IBAction func handleTapOnLogInButton(_ sender: Any) {
        print("Log in")
        CommunicationService.sharedInstace.logInWith(email: "", password: "") {
            (response: String?) in
            print("got response")
        }
        
    }
  
}

