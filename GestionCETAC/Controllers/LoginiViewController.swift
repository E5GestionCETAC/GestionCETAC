//
//  LoginiViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 27/09/21.
//

import UIKit

class LoginiViewController: UIViewController {

    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorText.alpha = 0
    }
    

    func validateFields() -> String? {
        if((usernameTextField.text?.isEmpty) != nil || (passwordTextField.text?.isEmpty) != nil){
            return "Los campos no pueden estar vacíos"
        }
        return nil
    }

    @IBAction func LogIn(_ sender: Any) {
        let error = validateFields()
        
        if error != nil{
            showError(error!)
        }
        
        //Autenticar usuario
        
        
        //Dar acceso a la siguieete pantalla
    }
    
    func showError(_ message: String) {
        errorText.text = message
        errorText.alpha = 1
    }
}
