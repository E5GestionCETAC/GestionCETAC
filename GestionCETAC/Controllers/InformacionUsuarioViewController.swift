//
//  InformacionUsuarioViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 03/10/21.
//

import UIKit
import Firebase

class InformacionUsuarioViewController: UIViewController {
    //Picker view
    var datePicker = UIDatePicker()
    let generos:[String] = ["", "Masculino", "Femenino", "Otro"]
    
    fileprivate let generoPickerView = ToolbarPickerView()
    //End picker view
    // Controladores
    let sesionControlador = sesionController()
    let usuarioControlador = usuarioController()
    // End Controladores
    
    // Datos de usuario
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var paternoText: UITextField!
    @IBOutlet weak var maternoText: UITextField!
    @IBOutlet weak var religionText: UITextField!
    @IBOutlet weak var ocupacionText: UITextField!
    @IBOutlet weak var procedenciaText: UITextField!
    @IBOutlet weak var domicilioText: UITextView!
    @IBOutlet weak var tel_casaText: UITextField!
    @IBOutlet weak var celularText: UITextField!
    @IBOutlet weak var estado_civilText: UITextField!
    @IBOutlet weak var fecha_nacimientoText: UITextField!
    @IBOutlet weak var sexoText: UITextField!
    @IBOutlet weak var numeroHijosText: UITextField!
    @IBOutlet weak var detalleHijosText: UITextView!
    @IBOutlet weak var referido_porText: UITextField!
    @IBOutlet weak var problemaText: UITextView!
    @IBOutlet weak var indicador_actitudinalText: UITextView!
    @IBOutlet weak var ekrText: UITextField!
    // End Datos de usuario
    
    // Bar buttons
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    // End Bar buttons
    
    // Otras variables
    
    @IBOutlet weak var scrollView: UIScrollView!
    var currentUser:Usuario?
    var firstSesion:Sesion?
    var editingMode:Bool = false
    let cetacUserRol:String = UserDefaults.standard.string(forKey: "currentCetacUserRol")!
    let cetacUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    var fechaNacimientoDate:Date?
    var edad:Int?
    // End Otras variables
    
    
    @IBAction func endEditing(_ sender: Any) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Picker View
        sexoText.inputView = generoPickerView
        sexoText.inputAccessoryView = generoPickerView.toolbar
        
        generoPickerView.delegate = self
        generoPickerView.dataSource = self
        generoPickerView.toolbarDelegate = self
        
        generoPickerView.tag = 1
        
        createDatePickerView()
        //End Picker View
        setStateButtons()
        setStateTextFields()
        setUserData()
        registerForKeyboardNotifications()
    }
    
    func setUserData(){
        // Datos de usuario
        nombreText.text = self.currentUser?.nombre
        paternoText.text = self.currentUser?.apellido_paterno
        maternoText.text = self.currentUser?.apellido_materno
        religionText.text = self.currentUser?.religion
        ocupacionText.text = self.currentUser?.ocupacion
        procedenciaText.text = self.currentUser?.procedencia
        domicilioText.text = self.currentUser?.domicilio
        tel_casaText.text = self.currentUser?.tel_casa
        celularText.text = self.currentUser?.celular
        estado_civilText.text = self.currentUser?.estado_civil
          // Fecha de nacimiento
        let fecha_nacimientoDate:Date = self.currentUser!.fecha_nacimiento.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        fecha_nacimientoText.text = dateFormatter.string(from: fecha_nacimientoDate)
          // End Fecha de nacimiento
        sexoText.text = self.currentUser?.sexo
        numeroHijosText.text = "\(self.currentUser!.numeroHijos)"
        detalleHijosText.text = self.currentUser?.detalleHijos
        referido_porText.text = self.currentUser?.referido_por
        problemaText.text = self.currentUser?.problema
        indicador_actitudinalText.text = self.currentUser?.indicador_actitudinal
        ekrText.text = self.currentUser?.ekr
        // End Datos de usuario
    }
    
    func setStateTextFields(){
        if editingMode == false{
            // Unable text fields and text views
            nombreText.isUserInteractionEnabled = false
            paternoText.isUserInteractionEnabled = false
            maternoText.isUserInteractionEnabled = false
            religionText.isUserInteractionEnabled = false
            ocupacionText.isUserInteractionEnabled = false
            procedenciaText.isUserInteractionEnabled = false
            domicilioText.isUserInteractionEnabled = false
            tel_casaText.isUserInteractionEnabled = false
            celularText.isUserInteractionEnabled = false
            estado_civilText.isUserInteractionEnabled = false
            fecha_nacimientoText.isUserInteractionEnabled = false
            sexoText.isUserInteractionEnabled = false
            numeroHijosText.isUserInteractionEnabled = false
            detalleHijosText.isEditable = false
            referido_porText.isUserInteractionEnabled = false
            problemaText.isUserInteractionEnabled = false
            indicador_actitudinalText.isEditable = false
            ekrText.isUserInteractionEnabled = false
            // End Unable text fields and text views
        }
        else{
            // Enable text fields and text views
            nombreText.isUserInteractionEnabled = true
            paternoText.isUserInteractionEnabled = true
            maternoText.isUserInteractionEnabled = true
            religionText.isUserInteractionEnabled = true
            ocupacionText.isUserInteractionEnabled = true
            procedenciaText.isUserInteractionEnabled = true
            domicilioText.isUserInteractionEnabled = true
            tel_casaText.isUserInteractionEnabled = true
            celularText.isUserInteractionEnabled = true
            estado_civilText.isUserInteractionEnabled = true
            fecha_nacimientoText.isUserInteractionEnabled = true
            sexoText.isUserInteractionEnabled = true
            numeroHijosText.isUserInteractionEnabled = true
            detalleHijosText.isEditable = true
            referido_porText.isUserInteractionEnabled = true
            problemaText.isEditable = true
            indicador_actitudinalText.isEditable = true
            ekrText.isUserInteractionEnabled = true
            // End Enable text fields and text views
        }
    }
    
    func setStateButtons(){
        if cetacUserRol == "Administrador" || cetacUserRol == "Tanatólogo"{
            return
        }
        else if cetacUserRol == "Soporte Admon"{
            editButton.isEnabled = false
            editButton.tintColor = UIColor.clear
            
            saveButton.isEnabled = false
            saveButton.tintColor = UIColor.clear
        }
        else{
            editButton.isEnabled = false
            editButton.tintColor = UIColor.clear
            
            saveButton.isEnabled = false
            saveButton.tintColor = UIColor.clear
        }
    }
    
    @IBAction func editUser(_ sender: Any) {
        if cetacUserRol == "Tanatólogo" || cetacUserRol == "Administrador"{
            self.editingMode = true
            setStateTextFields()
            displayMessage(title: "Acceso concedido", detalle: "Se ha dado acceso a la edición de la información personal del usuario")
        }
        else{
            editingMode = false
            setStateTextFields()
        }
    }
    
    @IBAction func saveUser(_ sender: Any) {
        if editingMode == true{
            let error = validateData()
            if let error = error {
                displayError(error, title: "Error")
            }else{
                // Crear usuario
                let fechaNacimientoTimestamp = Timestamp(date: fechaNacimientoDate!)
                let numeroHijosInt = Int(numeroHijosText.text!)!
                // Calcular edad---------------------------
                let now = Date()
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents([.year], from: fechaNacimientoDate!, to: now)
                self.edad = ageComponents.year!
                // End Calcular edad-----------------------
                let newUser:Usuario = Usuario(usuarioID:self.currentUser!.usuarioID,id: self.currentUser!.id, edad: self.edad!, nombre: self.nombreText.text!, apellido_paterno: self.paternoText.text!, apellido_materno: self.maternoText.text!, ocupacion: self.ocupacionText.text!, religion: self.religionText.text!, tel_casa: self.tel_casaText.text!, celular: self.celularText.text!, problema: self.problemaText.text!, estado_civil: self.estado_civilText.text!, sexo: self.sexoText.text!, ekr: self.ekrText.text!, indicador_actitudinal: self.indicador_actitudinalText.text!, domicilio: self.domicilioText.text!, procedencia: self.procedenciaText.text!, referido_por: self.referido_porText.text!, cetacUserID: self.currentUser!.cetacUserID, fecha_nacimiento: fechaNacimientoTimestamp, activo: true, numeroHijos: numeroHijosInt, detalleHijo: detalleHijosText.text!)
                
                usuarioControlador.updateUsuario(updateUsuario: newUser){(result) in
                    switch result{
                    case .success(_):self.displayExito(title: "Éxito", detalle: "Se actualizó la información correctamente")
                    case.failure(let error):self.displayError(error, title: "No se pudieron actualizar los datos del usuario")
                    }
                }
                // End Crear usuario
                editingMode = false
                setStateTextFields()
            }
        }
        else{
            displayMessage(title: "Modo edición no activado", detalle: "Active el modo de edición y actualice los campos que necesite")
        }
    }
    func validateData() -> Error? {
        if (nombreText.text!.isEmpty) || (paternoText.text!.isEmpty) || (maternoText.text!.isEmpty) || (religionText.text!.isEmpty) || (procedenciaText.text!.isEmpty) || (domicilioText.text!.isEmpty) || (tel_casaText.text!.isEmpty) || (celularText.text!.isEmpty) || (estado_civilText.text!.isEmpty) || (fecha_nacimientoText.text!.isEmpty) || (sexoText.text!.isEmpty) || (referido_porText.text!.isEmpty) || (problemaText.text!.isEmpty) || (indicador_actitudinalText.text!.isEmpty) || (ekrText.text!.isEmpty) {
            return CustomError.emptyUserFields
        }
        if isPhoneNumber(tel_casaText.text!) == false || isPhoneNumber(celularText.text!) == false{
            return CustomError.noNumber
        }
        if isNumber(numeroHijosText.text!) == false{
            return CustomError.emptyHijoFields
        }
        return nil
    }
    
    func isNumber(_ numero:String) -> Bool{
        let floatNumberRegex = "^\\d*\\.?\\d*$"
        let floatNumberTest = NSPredicate(format: "SELF MATCHES %@", floatNumberRegex)
        return floatNumberTest.evaluate(with: numero)
    }
    
    func isPhoneNumber(_ numero:String) -> Bool{
        let phoneNumberRegex = "^\\d{10}$"
        let phoneNumberTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return phoneNumberTest.evaluate(with: numero)
    }
    
    func displayExito(title : String, detalle : String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: detalle, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                self.performSegue(withIdentifier: "unwindToHome", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func displayMessage(title : String, detalle : String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: detalle, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func displayError(_ error: Error, title:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    // Date picker view -------------------------------
    func createDatePickerView() {
        self.fechaNacimientoDate = currentUser!.fecha_nacimiento.dateValue()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePicker))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        fecha_nacimientoText.inputAccessoryView = toolbar
        
        fecha_nacimientoText.inputView = datePicker
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        fecha_nacimientoText.text = formatter.string(from: datePicker.date)
        fechaNacimientoDate = datePicker.date
        self.view.endEditing(true)
    }
    // End Date picker view --------------------------
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
    }
}

extension InformacionUsuarioViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case 1:
            return self.generos.count
        default:
            return 1
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag{
        case 1:
            return self.generos[row]
        default:
            return "No hay datos"
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag{
        case 1:
            sexoText.text! = generos[row]
        default:
            return
        }
    }
}

extension InformacionUsuarioViewController : ToolbarPickerViewDelegate{
    func didTapDone() {
        self.view.endEditing(true)
    }
}
