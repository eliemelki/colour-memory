//
//  RecordScoreViewController.swift
//  ColourMemory
//
//  Created by Elie Melki on 20/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userInputView: InputView!
    weak var delegate: UserViewDelegate?
    var presenter: UserPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = DefaultUserPresenter()
        self.presenter.attach(view: self)
        self.userInputView.inputTextField.delegate = self
        self.view.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.view.layer.borderWidth = 1
        self.view.layer.cornerRadius = 30
    }

   
    @IBAction func didTapSave(_ sender: Any) {
        self.presenter.save(user: self.userInputView.inputTextField.text)
    }

}

extension UserViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.presenter.save(user: textField.text)
        return false
    }
}

extension UserViewController : UserView {
    func showMessage(_ message: String) {
        self.titleLabel.text = message
    }
    
    func clearUsernameValidationError() {
        self.userInputView.errorLabel.text = ""
        self.userInputView.setNeedsLayout()
        self.userInputView.layoutIfNeeded()
    }
    
    func done(user: String) {
        if let del = self.delegate {
            del.didSave(user: user)
        }
    }
    
    
    func showUsernameValidation(error: String) {
        self.userInputView.errorLabel.text = error
        self.userInputView.setNeedsLayout()
        self.userInputView.layoutIfNeeded()
    }
}
