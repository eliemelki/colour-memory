//
//  DefaultUserPresenter.swift
//  ColourMemory
//
//  Created by Elie Melki on 23/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit

class DefaultUserPresenter: NSObject, UserPresenter {
    
    weak var view:UserView?
    
    func attach(view: UserView) {
        self.view = view
    }
    
    func validate(user: String?) -> Bool {
        if (user == nil || user!.isEmpty) {
            self.view?.showUsernameValidation(error: "User cannot be empty")
            return false
        }
        
        self.view?.clearUsernameValidationError()
        return true
        
    }
    
    func save(user: String?) {
        if (self.validate(user: user)) {
            self.view?.done(user: user!)
        }
    }
    

}
