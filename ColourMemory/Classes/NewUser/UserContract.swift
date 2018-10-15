//
//  NewScoreContract.swift
//  ColourMemory
//
//  Created by Elie Melki on 20/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

protocol UserPresenter : class {
    func attach(view : UserView)
    func save(user : String?)
    
}

protocol UserViewDelegate : class {
    func didSave(user: String)
}

protocol UserView : class {
    func showMessage(_ message:String)
    func showUsernameValidation(error: String)
    func clearUsernameValidationError()
    func done(user: String)
    var delegate : UserViewDelegate? { get set }
    
    
}
