//
//  LoginiViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 27/09/21.
//

import UIKit
import FirebaseAuth
class LoginiViewController: UIViewController {

    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        errorText.alpha = 0
    }
    

    func validateFields() -> String? {
        if(emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty){
            return "Los campos no pueden estar vacíos"
        }
        return nil
    }

    @IBAction func LogIn(_ sender: Any) {
        let error = validateFields()
        
        if error != nil{
            showError(error!)
        }else{
            //Autenticar usuario
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                if error != nil{
                    self.showError(error!.localizedDescription)
                }else{
                    //Dar acceso a la siguieete pantalla
                    self.transitionToGestionCETAC()
                }
            }
        }
    }
    func transitionToGestionCETAC() {
        let HomeGestionCETAC = self.storyboard?.instantiateViewController(withIdentifier: "homeGestionCETAC") as? HomeGestionCETACViewController
        self.navigationController?.pushViewController(HomeGestionCETAC!, animated: true)
    }
    func showError(_ message: String) {
        errorText.text = message
        errorText.alpha = 1
    }
}
