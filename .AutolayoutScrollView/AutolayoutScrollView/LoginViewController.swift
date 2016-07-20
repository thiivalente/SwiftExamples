//
//  LoginViewController.swift
//  AutolayoutScrollView
//
//  Created by Andrea Prearo on 5/24/15.
//  Copyright (c) 2015 aprearo. All rights reserved.
//

import UIKit

let LoginToFirstSegue = "LoginToFirstSegue"

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    var didLayoutSubviews = false

    var initialContentSizeHeight: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        let defaultCenter = NotificationCenter.default()
        defaultCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        defaultCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if (didLayoutSubviews || scrollView.contentSize.height == 0.0) {
            return;
        }
        didLayoutSubviews = true
        initialContentSizeHeight = scrollView.contentSize.height
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        signInButtonTapped(textField)
        return true
    }

    // MARK: Keyboard Events

    func keyboardWillShow(_ notification: Notification) {
        if let keyboardHeight = (notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey]?.cgRectValue.size.height {
            var contentSize = scrollView.contentSize
            contentSize.height = initialContentSizeHeight + keyboardHeight
            scrollView.contentSize = contentSize
            scrollView.setContentOffset(CGPoint(x: 0, y: keyboardHeight), animated: true)
        }
    }

    func keyboardWillHide(_ notification: Notification) {
        var contentSize = scrollView.contentSize
        contentSize.height = initialContentSizeHeight
        scrollView.contentSize = contentSize
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARK: Actions
    
    @IBAction func signInButtonTapped(_ sender: AnyObject) {
        if let username = usernameTextField.text,
            let password = passwordTextField.text
            where !username.isEmpty && !password.isEmpty {
                performSegue(withIdentifier: LoginToFirstSegue, sender: self)
        } else {
            let alert = UIAlertView(title: "Error",
                                    message: "Any non-empty username/password combination works!",
                                    delegate: nil,
                                    cancelButtonTitle: "OK")
            alert.show()
        }
    }

    // MARK: Orientation Changes

    @available(iOS 8.0, *)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        didLayoutSubviews = false
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        super.willRotate(to: toInterfaceOrientation, duration: duration)
        guard #available(iOS 8, *) else {
            didLayoutSubviews = false
            return
        }
    }

}
