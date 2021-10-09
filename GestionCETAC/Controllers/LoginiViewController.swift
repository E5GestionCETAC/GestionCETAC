//
//  LoginiViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 27/09/21.
//

import UIKit
import FirebaseAuth
class LoginiViewController: UIViewController {

    // Datos del usuario CETAC
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    // End Datos del usuario CETAC
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.text! = ""
        passwordTextField.text = ""
        resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.tabBar.isHidden = true

    }
    
    func validateFields() -> Error? {
        if(emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty){
            return CustomError.emptyFields
        }
        if isValidEmail(emailTextField.text!) == false{
            return CustomError.invalidEmail
        }
        return nil
    }

    @IBAction func LogIn(_ sender: Any) {
        let error = validateFields()
        
        if error != nil{
            displayError(error!, title: "Datos inválidos")
        }else{
            //Autenticar usuario
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                if error != nil{
                    self.displayError(error!, title: "Usuario o contraseña inválido")
                }else{
                    UserDefaults.standard.set(result!.user.uid, forKey: "currentCetacUserUID")
                    self.transitionToGestionCETAC()
                }
            }
        }
    }
    
    func isValidEmail(_ email:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func transitionToGestionCETAC() {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    func displayError(_ error: Error, title:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
