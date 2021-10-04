//
//  InformacionUsuarioViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 03/10/21.
//

import UIKit
import Firebase

class InformacionUsuarioViewController: UIViewController {
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
    @IBOutlet weak var referido_porText: UITextField!
    @IBOutlet weak var problemaText: UITextView!
    @IBOutlet weak var indicador_actitudinalText: UITextView!
    @IBOutlet weak var ekrText: UITextField!
    // End Datos de usuario
    
    // Datos de sesion
    @IBOutlet weak var motivoText: UITextField!
    @IBOutlet weak var tipo_servicioText: UITextField!
    @IBOutlet weak var tipo_intervencionText: UITextField!
    @IBOutlet weak var herramientaText: UITextField!
    @IBOutlet weak var evaluacion_sesionText: UITextView!
    @IBOutlet weak var cuota_recuperacionText: UITextField!
    // End datos de sesion
    
    // Bar buttons
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    // End Bar buttons
    
    // Otras variables
    var currentUser:Usuario?
    var firstSesion:Sesion?
    var editingMode:Bool = false
    let cetacUserRol:String = UserDefaults.standard.string(forKey: "currentCetacUserRol")!
    let cetacUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    var fechaNacimientoDate:Date?
    var edad:Int?
    // End Otras variables
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStateButtons()
        setStateTextFields()
        
        // Inicializacion de picker viewa
        createDatePickerView()
        motivoText.inputView = motivoPickerView
        motivoText.inputAccessoryView = motivoPickerView.toolbar
        tipo_servicioText.inputView = servicioPickerView
        tipo_servicioText.inputAccessoryView = servicioPickerView.toolbar
        tipo_intervencionText.inputView = intervencionPickerView
        tipo_intervencionText.inputAccessoryView = intervencionPickerView.toolbar
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
        // End Inicializacion de picker views
        
        sesionControlador.getSesionNumber(userID: self.currentUser!.id, sesionNumber: 1){ (result) in
            switch result{
            case .success(let firsSesion):self.setUserData(firsSesion)
            case .failure(let error):self.displayError(error, title: "No se pudo obtener la primera sesión del usuario")
            }
        }

    }
    
    func setUserData(_ firstSesion:Sesion){
        self.firstSesion = firstSesion
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
        referido_porText.text = self.currentUser?.referido_por
        problemaText.text = self.currentUser?.problema
        indicador_actitudinalText.text = self.currentUser?.indicador_actitudinal
        ekrText.text = self.currentUser?.ekr
        // End Datos de usuario
        
        // Datos de sesion
        motivoText.text = firstSesion.motivo
        tipo_servicioText.text = firstSesion.tipo_servicio
        tipo_intervencionText.text = firstSesion.tipo_intervencion
        herramientaText.text = firstSesion.herramienta
        evaluacion_sesionText.text = firstSesion.evaluacion_sesion
        cuota_recuperacionText.text = firstSesion.cuota_recuperacion.description
        // End Datos de sesion
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
            referido_porText.isUserInteractionEnabled = false
            problemaText.isUserInteractionEnabled = false
            indicador_actitudinalText.isEditable = false
            ekrText.isUserInteractionEnabled = false
            
            motivoText.isUserInteractionEnabled = false
            tipo_servicioText.isUserInteractionEnabled = false
            tipo_intervencionText.isUserInteractionEnabled = false
            herramientaText.isUserInteractionEnabled = false
            evaluacion_sesionText.isEditable = false
            cuota_recuperacionText.isUserInteractionEnabled = false
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
            referido_porText.isUserInteractionEnabled = true
            problemaText.isEditable = true
            indicador_actitudinalText.isEditable = true
            ekrText.isUserInteractionEnabled = true
            
            motivoText.isUserInteractionEnabled = true
            tipo_servicioText.isUserInteractionEnabled = true
            tipo_intervencionText.isUserInteractionEnabled = true
            herramientaText.isUserInteractionEnabled = true
            evaluacion_sesionText.isEditable = true
            cuota_recuperacionText.isUserInteractionEnabled = true
            // End Enable text fields and text views
        }
    }
    
    func setStateButtons(){
        if cetacUserRol == "Administrador"{
            return
        }
        else if cetacUserRol == "Tanatólogo"{
            deleteButton.isEnabled = false
            deleteButton.tintColor = UIColor.clear
        }
        else if cetacUserRol == "Soporte Admon"{
            deleteButton.isEnabled = false
            deleteButton.tintColor = UIColor.clear
            
            editButton.isEnabled = false
            editButton.tintColor = UIColor.clear
            
            saveButton.isEnabled = false
            saveButton.tintColor = UIColor.clear
        }
        else{
            deleteButton.isEnabled = false
            deleteButton.tintColor = UIColor.clear
            
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
            displayMessage(title: "Tiene permiso para editar", detalle: "Se ha dado acceso a la edición de la información personal del usuario y su primera sesión")
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
                // Calcular edad---------------------------
                let now = Date()
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents([.year], from: fechaNacimientoDate!, to: now)
                self.edad = ageComponents.year!
                // End Calcular edad-----------------------
                let newUser:Usuario = Usuario(usuarioID:self.currentUser!.usuarioID,id: self.currentUser!.id, edad: self.edad!, nombre: self.nombreText.text!, apellido_paterno: self.paternoText.text!, apellido_materno: self.maternoText.text!, ocupacion: self.ocupacionText.text!, religion: self.religionText.text!, tel_casa: self.tel_casaText.text!, celular: self.celularText.text!, problema: self.problemaText.text!, estado_civil: self.estado_civilText.text!, sexo: self.sexoText.text!, ekr: self.ekrText.text!, indicador_actitudinal: self.indicador_actitudinalText.text!, domicilio: self.domicilioText.text!, procedencia: self.procedenciaText.text!, referido_por: self.referido_porText.text!, cetacUserID: self.cetacUserUID, fecha_nacimiento: fechaNacimientoTimestamp, activo: true)
                
                usuarioControlador.updateUsuario(updateUsuario: newUser){(result) in
                    switch result{
                    case .success(_):print("Exito actualizando usuario")
                    case.failure(let error):self.displayError(error, title: "No se pudieron actualizar los datos del usuario")
                    }
                }
                // End Crear usuario
                
                // Crear sesion
                let cuotaRecuperacionFloat = Float(cuota_recuperacionText.text!)
                
                let newSesion:Sesion = Sesion(sesionID:self.firstSesion!.sesionID,usuarioID: self.currentUser!.id, numero_sesion: 1, cuota_recuperacion: cuotaRecuperacionFloat!, tanatologoUID: cetacUserUID, motivo: motivoText.text!, tipo_servicio: tipo_servicioText.text!, tipo_intervencion: tipo_intervencionText.text!, herramienta: herramientaText.text!, evaluacion_sesion: evaluacion_sesionText.text!, fecha: Timestamp())
                
                sesionControlador.updateSesion(updateSesion: newSesion){ (result) in
                    switch result{
                    case .success(_):self.displayExito(title: "Éxito", detalle: "Se actualizaron los datos del usuario")
                    case .failure(let error):self.displayError(error, title: "No se pudieron actualizar los datos del usuario")
                    }
                }
                // End crear sesion
                editingMode = false
                setStateTextFields()
            }
        }
        else{
            displayMessage(title: "Modo edición no activado", detalle: "Active el modo de edición y actualice los campos que necesite")
        }
    }
    
    @IBAction func deleteUser(_ sender: Any) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Eliminar usuario", message: "¿Está seguro de borrar este usuario?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                (action: UIAlertAction!) in
                self.usuarioControlador.deleteUsuario(deleteUsuario: self.currentUser!){ (result) in
                    switch result{
                    case .success(let retorno):self.displayExito(title: "Éxito", detalle: retorno)
                    case .failure(let error):self.displayError(error, title: "Error")
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func validateData() -> Error? {
        if (nombreText.text!.isEmpty) || (paternoText.text!.isEmpty) || (maternoText.text!.isEmpty) || (religionText.text!.isEmpty) || (procedenciaText.text!.isEmpty) || (domicilioText.text!.isEmpty) || (tel_casaText.text!.isEmpty) || (celularText.text!.isEmpty) || (estado_civilText.text!.isEmpty) || (fecha_nacimientoText.text!.isEmpty) || (sexoText.text!.isEmpty) || (referido_porText.text!.isEmpty) || (problemaText.text!.isEmpty) || (indicador_actitudinalText.text!.isEmpty) || (ekrText.text!.isEmpty) {
            return CustomError.emptyUserFields
        }
        if (motivoText.text!.isEmpty || tipo_servicioText.text!.isEmpty || tipo_intervencionText.text!.isEmpty || herramientaText.text!.isEmpty || evaluacion_sesionText.text!.isEmpty || cuota_recuperacionText.text!.isEmpty){
            return CustomError.emptySesionFields
        }
        if isNumber(cuota_recuperacionText.text!) == false{
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
}

extension InformacionUsuarioViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
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
            tipo_servicioText.text! = servicios[row]
        case 3:
            tipo_intervencionText.text! = intervenciones[row]
        case 4:
            herramientaText.text! = herramientas[row]
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

