//
//  SeguimientoSesionViewController.swift
//  GestionCETAC
//
//  Created by user195142 on 10/5/21.
//

import UIKit
import Firebase

class SeguimientoSesionViewController: UIViewController {
    
    // Picker views
    let datePicker = UIDatePicker()
    
    let servicios:[String] = ["","Servicios de Acompañamiento", "Servicios Holísticos", "Herramientas Alternativas"]
    let motivos:[String] = ["","Abuso","Adicción","Ansiedad","Baja autoestima","Codependencia","Comunicación familiar","Conflicto con hermano","Conflicto con madre","Conflicto con padre","Dependencia","Divorcio","Duelo","Duelo grupal","Enfermedad","Enfermedad crónico degenerativa","Heridas de la infancia","Identidad de género","Infertilidad","Infidelidad","Intento de suicidio","Miedo","Pérdida de bienes materiales","Pérdida de identidad","Pérdida laboral","Relación con los padres","Ruptura de Noviazgo","Stress","Trastorno Obsesivo","Violación","Violencia intrafamiliar","Violencia psicológica","Viudez","Otro"]
    let intervenciones:[String] = ["","Tanatología", "Acompañamiento Individual", "Acompañamiento Grupal", "Logoterapia", "Mindfulness", "Aromaterapia y Musicoterapia", "Cristaloterapia", "Reiki", "Biomagnetismo", "Angeloterapia", "Cama Térmica De Jade", "Flores De Bach", "Brisas Ambientales"]
    let herramientas:[String] = ["","Contención","Diálogo","Ejercicio","Encuadre","Infografía","Dinámica","Lectura","Meditación","Video","Otro"]
    
    fileprivate let servicioPickerView = ToolbarPickerView()
    fileprivate let motivoPickerView = ToolbarPickerView()
    fileprivate let intervencionPickerView = ToolbarPickerView()
    fileprivate let herramientaPickerView = ToolbarPickerView()
    fileprivate let usuarioPickerView = ToolbarPickerView()
    // End Picker view
    
    // Controladores
    var usuarioControlador = usuarioController()
    var sesionControlador = sesionController()
    // End Controladores
    
    // Datos de sesion---------------------------------
    @IBOutlet weak var usuarioText: UITextField!
    @IBOutlet weak var motivoText: UITextField!
    @IBOutlet weak var tipo_servicioText: UITextField!
    @IBOutlet weak var tipo_intervencionText: UITextField!
    @IBOutlet weak var herramientaText: UITextField!
    @IBOutlet weak var evaluacion_sesionText: UITextView!
    @IBOutlet weak var cuota_recuperacionText: UITextField!
    // End Datos de sesion-----------------------------
    
    // Switches
    @IBOutlet weak var cerrarExpedienteSwitch: UISwitch!
    @IBOutlet weak var terminosCondicionesSwitch: UISwitch!
    // End Switches
    
    // Other variables
    @IBOutlet weak var scrollView: UIScrollView!
    var sesionID:Int?
    var dictionaryUser:[String:Int] = [:]
    var usuarios = [Usuario]()
    var currentUser:Usuario?
    let cetacUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    let currentCetacUserRol:String = UserDefaults.standard.string(forKey: "currentCetacUserRol")!
    //End other variables

    
    @IBAction func endEditing(_ sender: Any) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Picker Views
        motivoText.inputView = motivoPickerView
        motivoText.inputAccessoryView = motivoPickerView.toolbar
        usuarioText.inputView = usuarioPickerView
        usuarioText.inputAccessoryView = usuarioPickerView.toolbar
        tipo_servicioText.inputView = servicioPickerView
        tipo_servicioText.inputAccessoryView = servicioPickerView.toolbar
        tipo_intervencionText.inputView = intervencionPickerView
        tipo_intervencionText.inputAccessoryView = intervencionPickerView.toolbar
        herramientaText.inputView = herramientaPickerView
        herramientaText.inputAccessoryView = herramientaPickerView.toolbar
        
        usuarioPickerView.delegate = self
        usuarioPickerView.dataSource = self
        usuarioPickerView.toolbarDelegate = self
        motivoPickerView.delegate = self
        motivoPickerView.dataSource = self
        motivoPickerView.toolbarDelegate = self
        servicioPickerView.delegate = self
        servicioPickerView.dataSource = self
        servicioPickerView.toolbarDelegate = self
        intervencionPickerView.delegate = self
        intervencionPickerView.dataSource = self
        intervencionPickerView.toolbarDelegate = self
        herramientaPickerView.delegate = self
        herramientaPickerView.dataSource = self
        herramientaPickerView.toolbarDelegate = self
        
        usuarioPickerView.tag = 5
        motivoPickerView.tag = 1
        servicioPickerView.tag = 2
        intervencionPickerView.tag = 3
        herramientaPickerView.tag = 4
        //Picker views
        
        if currentCetacUserRol == "Administrador" || currentCetacUserRol == "Soporte Admon"{
            self.usuarioControlador.fetchActiveUsuarios{ (result) in
                switch result{
                case .success(let users):self.setUsuarios(users)
                case .failure(let error):self.displayError(error, title: "No se obtuvieron los usuarios")
                }
            }
        }else if currentCetacUserRol == "Tanatólogo"{
            self.usuarioControlador.fetchActiveUsuariosFromCetacUser{(result) in
                switch result{
                case .success(let users):self.setUsuarios(users)
                case .failure(let error):self.displayError(error, title: "No se obtuvieron los usuarios")
                }
            }
        }
        registerForKeyboardNotifications()
    }
    
    @IBAction func seguimientoSesion(_ sender: Any) {
        let error = validateData()
        if let error = error {
            displayError(error, title: "Error")
        }else{
            let id = dictionaryUser.index(forKey:usuarioText.text!)
            sesionControlador.getLastSesion(userID: dictionaryUser[id!].value){
                (result) in
                switch result
                {
                case .success(let sesion):self.sendSesion(sesion.numero_sesion)
                case .failure(let error): self.displayError(error, title: "No se obtuvo el id de la sesion")
                }
            }

        }
    }
    
    func setUsuarios(_ users:Usuarios){
        self.usuarios = users
        for user in users{
            dictionaryUser["\(user.nombre) \(user.apellido_paterno) \(user.apellido_materno)"] = user.id
        }
    }
    
    func sendSesion(_ numero_sesion:Int){
        let id = dictionaryUser.index(forKey:usuarioText.text!)
        // Crear sesion
        let cuotaRecuperacionFloat = Float(cuota_recuperacionText.text!)
        let newSesion:Sesion = Sesion(usuarioID: dictionaryUser[id!].value, numero_sesion: numero_sesion + 1, cuota_recuperacion: cuotaRecuperacionFloat!, tanatologoUID: cetacUserUID, motivo: motivoText.text!, tipo_servicio: tipo_servicioText.text!, tipo_intervencion: tipo_intervencionText.text!, herramienta: herramientaText.text!, evaluacion_sesion: evaluacion_sesionText.text!, fecha: Timestamp())
        sesionControlador.insertSesion(nuevaSesion: newSesion){ (result) in
            switch result{
            case .success(_):self.displayExito(title: "Éxito", detalle: "Se insertaron los datos correctamente")
            case .failure(let error):self.displayError(error, title: "No pudo guardar la sesión")
            }
        }
        if cerrarExpedienteSwitch.isOn {
            usuarioControlador.setUserInactive(usuarioID: currentUser!.usuarioID){(result) in
                switch result{
                case.success(let retorno): print(retorno)
                case .failure(let error): print(error)
                }
            }
        }
        // End crear sesion
    }
    
    func validateData() -> Error? {
        if (motivoText.text!.isEmpty || tipo_servicioText.text!.isEmpty || tipo_intervencionText.text!.isEmpty || herramientaText.text!.isEmpty || evaluacion_sesionText.text!.isEmpty || cuota_recuperacionText.text!.isEmpty || usuarioText.text!.isEmpty){
            return CustomError.emptySesionFields
        }
        if isNumber(cuota_recuperacionText.text!) == false{
            return CustomError.noMatchCuota
        }
        if terminosCondicionesSwitch.isOn == false{
            return CustomError.uncheckedPrivacyNotice
        }
        return nil
    }
    func isNumber(_ cuotaRecuperacion:String) -> Bool{
        let floatNumberRegex = "^\\d*\\.?\\d*$"
        let floatNumberTest = NSPredicate(format: "SELF MATCHES %@", floatNumberRegex)
        return floatNumberTest.evaluate(with: cuotaRecuperacion)
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
    
    func displayError(_ error: Error, title:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
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

extension SeguimientoSesionViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case 1:
            return self.motivos.count
        case 2:
            return self.servicios.count
        case 3:
            return self.intervenciones.count
        case 4:
            return self.herramientas.count
        case 5:
            return self.dictionaryUser.count
        default:
            return 1
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag{
        case 1:
            return self.motivos[row]
        case 2:
            return self.servicios[row]
        case 3:
            return self.intervenciones[row]
        case 4:
            return self.herramientas[row]
        case 5:
            return self.dictionaryUser.key(forValue: usuarios[row].id)!
        default:
            return "No hay datos"
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag{
        case 1:
            motivoText.text! = motivos[row]
        case 2:
            tipo_servicioText.text! = servicios[row]
        case 3:
            tipo_intervencionText.text! = intervenciones[row]
        case 4:
            herramientaText.text! = herramientas[row]
        case 5:
            currentUser = usuarios[row]
            usuarioText.text! = dictionaryUser.key(forValue: usuarios[row].id)!
        default:
            return
        }
    }
}

extension SeguimientoSesionViewController : ToolbarPickerViewDelegate{
    func didTapDone() {
        self.view.endEditing(true)
    }
}
extension Dictionary where Value: Equatable {
    func key(forValue val: Value) -> Key? {
        return self.first(where: { $1 == val })?.key
    }
}
