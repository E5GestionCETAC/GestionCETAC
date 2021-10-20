//
//  ReportesViewController.swift
//  GestionCETAC
//
//  Created by Diógenes Grajales Corona on 06/10/21.
//

import UIKit
import Firebase

class ReportesInfoViewController: UIViewController {
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
    // End Picker view
    
    // Controladores
    let sesionControlador = sesionController()
    let usuarioControlador = usuarioController()
    var tanaControlador = cetacUserController()

    @IBOutlet weak var expedienteID: UITextField!
    @IBOutlet weak var sesionID: UITextField!
    @IBOutlet weak var usuarioText: UITextField!
    @IBOutlet weak var fechaText: UITextField!
    @IBOutlet weak var tanaText: UITextField!
    @IBOutlet weak var motivoText: UITextField!
    @IBOutlet weak var servicioText: UITextField!
    @IBOutlet weak var intervencionText: UITextField!
    @IBOutlet weak var herramientaText: UITextField!
    @IBOutlet weak var evaluacionText: UITextView!
    @IBOutlet weak var cuotaText: UITextField!
    
    // Bar buttons
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var currentUser:Usuario?
    var currentSesion:Sesion?
    var editingMode:Bool = false
    let cetacUserRol:String = UserDefaults.standard.string(forKey: "currentCetacUserRol")!
    let cetacUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    var fechaNacimientoDate:Date?
    var edad:Int?
    
    
    @IBAction func endEditing(_ sender: Any) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStateTextFields()
        setStateButtons()
        
        //createDatePickerView()
        motivoText.inputView = motivoPickerView
        motivoText.inputAccessoryView = motivoPickerView.toolbar
        servicioText.inputView = servicioPickerView
        servicioText.inputAccessoryView = servicioPickerView.toolbar
        intervencionText.inputView = intervencionPickerView
        intervencionText.inputAccessoryView = intervencionPickerView.toolbar
        herramientaText.inputView = herramientaPickerView
        herramientaText.inputAccessoryView = herramientaPickerView.toolbar
        
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
        
        motivoPickerView.tag = 1
        servicioPickerView.tag = 2
        intervencionPickerView.tag = 3
        herramientaPickerView.tag = 4
        
        usuarioControlador.getUser(userID: currentSesion!.usuarioID){ (result) in
            switch result{
            case .success(let usuariod): self.setUserInfo(usuariod)
            case .failure(let error):self.displayError(error, title: "No se pudo obtener el usuario")
            }
            
        }
        
        tanaControlador.fetchCetacUsuarioWithUID(cetacUserUID: currentSesion!.tanatologoUID){ (result) in
            switch result{
            case .success(let tanatologo): self.setTana(tanatologo)
            case .failure(let error):self.displayError(error, title: "No se pudo obtener el tanatologo")
            }
        }
        
        registerForKeyboardNotifications()
    }
    
    func setUserInfo(_ currentUser:Usuario){
        self.currentUser = currentUser
        expedienteID.text = String(currentUser.id)
        usuarioText.text = "\(currentUser.nombre)\(" ")\(currentUser.apellido_paterno)\(" ")\(currentUser.apellido_materno)"
        sesionID.text = String(currentSesion!.numero_sesion)
        //tanaText.text = firstSesion!.tanatologoUID
        let fecha_sesion:Date = currentSesion!.fecha.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        fechaText.text = dateFormatter.string(from: fecha_sesion)
        
        motivoText.text = currentSesion!.motivo
        servicioText.text = currentSesion!.tipo_servicio
        intervencionText.text = currentSesion!.tipo_intervencion
        herramientaText.text = currentSesion!.herramienta
        evaluacionText.text = currentSesion!.evaluacion_sesion
        cuotaText.text = currentSesion!.cuota_recuperacion.description
    }
    
    func setTana(_ tana:cetacUser){
        tanaText.text = "\(tana.nombre)\(" ")\(tana.apellidos)"
    }
    
    func setStateTextFields(){
        sesionID.isUserInteractionEnabled = false
        expedienteID.isUserInteractionEnabled = false
        tanaText.isUserInteractionEnabled = false
        usuarioText.isUserInteractionEnabled = false
        fechaText.isUserInteractionEnabled = false
        
        if editingMode == false{
            // Unable text fields and text views
            
            motivoText.isUserInteractionEnabled = false
            servicioText.isUserInteractionEnabled = false
            intervencionText.isUserInteractionEnabled = false
            herramientaText.isUserInteractionEnabled = false
            evaluacionText.isEditable = false
            cuotaText.isUserInteractionEnabled = false
            // End Unable text fields and text views
        }
        else{
            // Enable text fields and text views
            
            motivoText.isUserInteractionEnabled = true
            servicioText.isUserInteractionEnabled = true
            intervencionText.isUserInteractionEnabled = true
            herramientaText.isUserInteractionEnabled = true
            evaluacionText.isEditable = true
            cuotaText.isUserInteractionEnabled = true
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
            displayMessage(title: "Acceso concedido", detalle: "Se ha dado acceso a la edición de la sesión del usuario")
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
                // Crear sesion
                let cuotaRecuperacionFloat = Float(cuotaText.text!)
                
                let newSesion:Sesion = Sesion(sesionID:self.currentSesion!.sesionID,usuarioID: self.currentUser!.id, numero_sesion: self.currentSesion!.numero_sesion, cuota_recuperacion: cuotaRecuperacionFloat!, tanatologoUID: self.currentSesion!.tanatologoUID, motivo: motivoText.text!, tipo_servicio: servicioText.text!, tipo_intervencion: intervencionText.text!, herramienta: herramientaText.text!, evaluacion_sesion: evaluacionText.text!, fecha: Timestamp())
                
                sesionControlador.updateSesion(updateSesion: newSesion){ (result) in
                    switch result{
                    case .success(_):self.displayExito(title: "Éxito", detalle: "Se actualizaron los datos de la sesión")
                    case .failure(let error):self.displayError(error, title: "No se pudieron actualizar los datos de la sesión")
                    }
                }
                // End crear sesion
                editingMode = false
                setStateTextFields()
            }
        }
        else{
            displayMessage(title: "Modo edición no activado", detalle: "Active el modo de edición para poder editar los campos")
        }
    }
    
    func validateData() -> Error? {
        if (usuarioText.text!.isEmpty) {
            return CustomError.emptyUserFields
        }
        if (fechaText.text!.isEmpty || motivoText.text!.isEmpty || servicioText.text!.isEmpty || intervencionText.text!.isEmpty || herramientaText.text!.isEmpty || evaluacionText.text!.isEmpty || cuotaText.text!.isEmpty){
            return CustomError.emptySesionFields
        }
        if isNumber(cuotaText.text!) == false{
            return CustomError.noMatchCuota
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
                self.performSegue(withIdentifier: "unwindToHome", sender: nil)
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
    
    /*func createDatePickerView() {
        self.fechaNacimientoDate = currentUser!.fecha_nacimiento.dateValue()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePicker))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        fechaText.inputAccessoryView = toolbar
        
        fechaText.inputView = datePicker
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }*/
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        fechaText.text = formatter.string(from: datePicker.date)
        fechaNacimientoDate = datePicker.date
        self.view.endEditing(true)
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

extension ReportesInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
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
        default:
            return "No hay datos"
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag{
        case 1:
            motivoText.text! = motivos[row]
        case 2:
            servicioText.text! = servicios[row]
        case 3:
            intervencionText.text! = intervenciones[row]
        case 4:
            herramientaText.text! = herramientas[row]
        default:
            return
        }
    }
}

extension ReportesInfoViewController : ToolbarPickerViewDelegate{
    func didTapDone() {
        self.view.endEditing(true)
    }
}

