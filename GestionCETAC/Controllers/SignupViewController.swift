//
//  SignupViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 27/09/21.
//

import UIKit

class SignupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var nombreTextField: UITextField!
    
    @IBOutlet weak var apellidoTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var rolPickerView: UIPickerView!
    
    let pickerViewData = [String] (arrayLiteral: "Tanatólogo", "Soporte Admon", "Administrador")
    
    var rol:String = "Tanatólogo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        rolPickerView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    @IBAction func SignUp(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        
        //Crear usuario
        
        //Registrar usuario a la base de datos
        
    }
    
    func validateFields() -> String? {
        if((nombreTextField.text?.isEmpty) != nil || (apellidoTextField.text?.isEmpty) != nil || (usernameTextField.text?.isEmpty) != nil || (emailTextField.text?.isEmpty) != nil || (passwordTextField.text?.isEmpty) != nil || rol.isEmpty){
            print(rol)
            return "Los campos no pueden estar vacíos"
        }
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    //Picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rol = pickerViewData[row]
    }
}
