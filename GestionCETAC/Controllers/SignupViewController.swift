//
//  SignupViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 27/09/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignupViewController: UIViewController {
    
    let cetacUsuarioControlador = cetacUserController()
    
    // Datos de Miembro CETAC
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var rolTextField: UITextField!
    // End Datos de Miembro CETAC
    
    // ToolBarPickerView
    let roles:[String] = ["","Tanatólogo", "Soporte Admon", "Administrador"]
    fileprivate let rolPickerView = ToolbarPickerView()
    // End ToolBarPickerView
    
    override func viewDidAppear(_ animated: Bool) {
        nombreTextField.text = ""
        apellidoTextField.text = ""
        emailTextField.text = ""
        password1TextField.text = ""
        password2TextField.text = ""
        rolTextField.text = ""
        resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Picker view
        rolTextField.inputView = rolPickerView
        rolTextField.inputAccessoryView = rolPickerView.toolbar
        rolPickerView.delegate = self
        rolPickerView.dataSource = self
        rolPickerView.toolbarDelegate = self
        // End Picker view
        
        //self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignUp(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            displayError(error!, title: "Datos inválidos")
        }
        else{
            //Crear usuario
            let newUser = cetacUser(nombre: nombreTextField.text!, apellidos: apellidoTextField.text!, rol: rolTextField.text!, email: emailTextField.text!, password: password1TextField.text!)
            cetacUsuarioControlador.createUser(user: newUser){ (result) in
                switch result{
                case .success(_): self.transitionToGestionCETAC()
                case .failure(let error): self.displayError(error, title: "No se pudo crear el usuario")
                }
            }
            // End crear usuario
        }
    }
    
    func validateFields()  -> Error?  {
        if (nombreTextField.text!.isEmpty || apellidoTextField.text!.isEmpty ||  emailTextField.text!.isEmpty || password1TextField.text!.isEmpty || rolTextField.text!.isEmpty || password2TextField.text!.isEmpty){
            return CustomError.emptyFields
        }
        if isValidEmail(emailTextField.text!) == false {
            return CustomError.invalidEmail
        }
        if password1TextField.text! != password2TextField.text! {
            return CustomError.noMatchPassword
        }
        if isValidPassword(password1TextField.text!) == false{
            return CustomError.invalidPassword
        }
        return nil
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
// Tool Bar Picker View
extension SignupViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.rolTextField.text = roles[row]
    }
}
// End Tool Bar Picker View

extension SignupViewController:ToolbarPickerViewDelegate{
    func didTapDone() {
        self.view.endEditing(true)
    }
}

// Custom error
enum CustomError:Error{
    case invalidPassword
    case invalidEmail
    case noMatchPassword
    case emptyFields
    case emptyUserFields
    case emptySesionFields
    case uncheckedPrivacyNotice
    case noPrivileges
    case noNumber
    case noMatchCuota
    case emptyHijoFields
    case noMatchHijoInfo
    case notFound
    case unexpected(code:Int)
}

extension CustomError{
    var isFatal:Bool{
        if case CustomError.unexpected = self{return true}
        else{return false}
    }
}

extension CustomError : LocalizedError{
    public var errorDescription: String?{
        switch self {
        case .invalidPassword:
            return NSLocalizedString("La contraseña no es segura. Debe de contener por lo menos 8 carácteres, 1 carácter especial, 1 mayúscula, 1 minúscula y 1 número", comment: "Contraseña inválida")
        case .invalidEmail:
            return NSLocalizedString("El correo electrónico es inválido", comment: "Correo electrónico inválido")
        case .noMatchPassword:
            return NSLocalizedString("Las contraseñas no coinciden", comment: "Contraseña no coinciden")
        case .emptyFields:
            return NSLocalizedString("Los campos no pueden estar vacíos", comment: "Campos vacíos")
        case .emptyUserFields:
            return NSLocalizedString("Los datos del usuario no pueden estar vacíos", comment: "Campos del usuario vacíos")
        case .emptySesionFields:
            return NSLocalizedString("Los datos de la sesión no pueden estar vacíos", comment: "Campos de la sesión vacíos")
        case .uncheckedPrivacyNotice:
            return NSLocalizedString("No se han aceptado los Términos y Condiciones del servicio", comment: "No se aceptaron las políticas")
        case .noPrivileges:
            return NSLocalizedString("No cuenta con los privilegios para realizar esta acción", comment: "No tiene privilegios para esta acción")
        case .noNumber:
            return NSLocalizedString("El valor deber ser un número", comment: "El tipo de valor no es el esperado")
        case .noMatchCuota:
            return NSLocalizedString("El valor de Cuota de recuperación deber ser un número", comment: "El tipo de valor no es el esperado")
        case . emptyHijoFields:
            return NSLocalizedString("Introduza el número de hijos. Si no hay, introduzca 0", comment: "No hay número de hijos")
        case .noMatchHijoInfo:
            return NSLocalizedString("El número de elementos no coincide con el número de hijos", comment: "No coincide el número de hijos y el resto de la información")
        case .notFound:
            return NSLocalizedString("Información no encontrada", comment: "Info Not Found")
        case .unexpected(_):
            return NSLocalizedString("Error inesperado", comment: "Error inesperado")
        }
    }
}
// End Custom error
