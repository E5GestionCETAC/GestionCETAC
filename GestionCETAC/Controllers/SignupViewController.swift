//
//  SignupViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 27/09/21.
//

import UIKit
import FirebaseAuth
import Firebase

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
        else{
            //Cleaned versions of data
            let nombre = nombreTextField.text!
            let apellidos = apellidoTextField.text!
            let username = usernameTextField.text!
            let email = emailTextField.text!
            let password = passwordTextField.text!
            //Crear usuario
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error{
                    self.showError(error.localizedDescription)
                }else{
                    //Registrar usuario a la base de datos
                    let db = Firestore.firestore()
                    db.collection("cetacUsers").addDocument(data: ["nombre":nombre, "apellidos" : apellidos, "rol": self.rol, "usuario":username, "uid": result!.user.uid]) { (error) in
                        if error != nil{
                            self.showError(error!.localizedDescription)
                        }
                    }
                    self.transitionToGestionCETAC()
                }
            }
        }
    }
    
    func validateFields() -> String? {
        if (nombreTextField.text!.isEmpty || apellidoTextField.text!.isEmpty || usernameTextField.text!.isEmpty || emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty || rol.isEmpty){
            
            return "Los campos no pueden estar vacíos"
        }
        if isValidEmail(emailTextField.text!) == false {
            return "El correo electrónico es inválido"
        }
        if isValidPassword(passwordTextField.text!) == false {
            return "La contraseña no es segura"
        }
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func isValidEmail(_ email:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func isValidPassword(_ password:String) -> Bool {
        //Password de por lo menos 8 caracteres que tiene por lo menos 1 letra minuscula, 1 letra mayuscula y 1 caracter especial
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,16}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    func transitionToGestionCETAC() {
        let HomeGestionCETAC = self.storyboard?.instantiateViewController(withIdentifier: "homeGestionCETAC") as? HomeGestionCETACViewController
        self.navigationController?.pushViewController(HomeGestionCETAC!, animated: true)
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
