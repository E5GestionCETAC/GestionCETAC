//
//  EncuadreViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 29/09/21.
//

import UIKit
import Firebase

class EncuadreViewController: UIViewController {
    // Picker views
    let datePicker = UIDatePicker()
    
    let servicios:[String] = ["","Servicios de Acompañamiento", "Servicios Holísticos", "Herramientas Alternativas"]
    let motivos:[String] = ["","Abuso","Adicción","Ansiedad","Baja autoestima","Codependencia","Comunicación familiar","Conflicto con hermano","Conflicto con madre","Conflicto con padre","Dependencia","Divorcio","Duelo","Duelo grupal","Enfermedad","Enfermedad crónico degenerativa","Heridas de la infancia","Identidad de género","Infertilidad","Infidelidad","Intento de suicidio","Miedo","Pérdida de bienes materiales","Pérdida de identidad","Pérdida laboral","Relación con los padres","Ruptura de Noviazgo","Stress","Trastorno Obsesivo","Violación","Violencia intrafamiliar","Violencia psicológica","Viudez","Otro"]
    let intervenciones:[String] = ["","Tanatología", "Acompañamiento Individual", "Acompañamiento Grupal", "Logoterapia", "Mindfulness", "Aromaterapia y Musicoterapia", "Cristaloterapia", "Reiki", "Biomagnetismo", "Angeloterapia", "Cama Térmica De Jade", "Flores De Bach", "Brisas Ambientales"]
    let herramientas:[String] = ["","Contención","Diálogo","Ejercicio","Encuadre","Infografía","Dinámica","Lectura","Meditación","Video","Otro"]
    let generos:[String] = ["", "Maculino", "Femenino", "Otro"]
    
    fileprivate let servicioPickerView = ToolbarPickerView()
    fileprivate let motivoPickerView = ToolbarPickerView()
    fileprivate let intervencionPickerView = ToolbarPickerView()
    fileprivate let herramientaPickerView = ToolbarPickerView()
    fileprivate let generoPickerView = ToolbarPickerView()
    // End Picker view
    
    // Controladores
    var userController = usuarioController()
    var sesionControlador = sesionController()
    // End Controladores
    
    // Datos de usuario--------------------------------
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
    // End Datos de usuarios---------------------------
    
    // Datos de sesion---------------------------------
    @IBOutlet weak var motivoText: UITextField!
    @IBOutlet weak var tipo_servicioText: UITextField!
    @IBOutlet weak var tipo_intervencionText: UITextField!
    @IBOutlet weak var herramientaText: UITextField!
    @IBOutlet weak var evaluacion_sesionText: UITextView!
    @IBOutlet weak var cuota_recuperacionText: UITextField!
    // End Datos de sesion-----------------------------
    
    // Switches
    @IBOutlet weak var abrirExpedienteSwitch: UISwitch!
    @IBOutlet weak var terminosCondicionesSwitch: UISwitch!
    // End Switches
    
    // Otras Variable
    var id:Int?
    let cetacUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    let currentRol:String = UserDefaults.standard.string(forKey: "currentCetacUserRol")!
    var fechaNacimientoDate:Date?
    var edad:Int?
    // End Otras Variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        sexoText.inputView = generoPickerView
        sexoText.inputAccessoryView = generoPickerView.toolbar
        
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
        generoPickerView.delegate = self
        generoPickerView.dataSource = self
        generoPickerView.toolbarDelegate = self
        
        motivoPickerView.tag = 1
        servicioPickerView.tag = 2
        intervencionPickerView.tag = 3
        herramientaPickerView.tag = 4
        generoPickerView.tag = 5
        // End Inicializacion de picker views
        
        self.userController.getLastID{ (result) in
            switch result{
            case .success(let lastID): self.id = lastID + 1
            case .failure(let error): self.displayError(error, title: "No se encontró el último ID")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func encuadre(_ sender: Any) {
        let error = validateData()
        if let error = error {
            displayError(error, title: "Error")
        }else{
            // Crear usuario
            let numeroHijosInt = Int(numeroHijosText.text!)
            let fechaNacimientoTimestamp = Timestamp(date: fechaNacimientoDate!)
            // Calcular edad---------------------------
            let now = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: fechaNacimientoDate!, to: now)
            self.edad = ageComponents.year!
            // End Calcular edad-----------------------
            let newUser:Usuario = Usuario(id: self.id!, edad: self.edad!, nombre: self.nombreText.text!, apellido_paterno: self.paternoText.text!, apellido_materno: self.maternoText.text!, ocupacion: self.ocupacionText.text!, religion: self.religionText.text!, tel_casa: self.tel_casaText.text!, celular: self.celularText.text!, problema: self.problemaText.text!, estado_civil: self.estado_civilText.text!, sexo: self.sexoText.text!, ekr: self.ekrText.text!, indicador_actitudinal: self.indicador_actitudinalText.text!, domicilio: self.domicilioText.text!, procedencia: self.procedenciaText.text!, referido_por: self.referido_porText.text!, cetacUserID: self.cetacUserUID, fecha_nacimiento: fechaNacimientoTimestamp, activo: true, numeroHijos: numeroHijosInt!, detalleHijo: detalleHijosText.text!)
            
            userController.insertUsuario(nuevoUsuario: newUser){(result) in
                switch result{
                case .success(let retorno):print(retorno)
                case.failure(let error):self.displayError(error, title: "No se guardó el usuario")
                }
            }
            // End Crear usuario
            
            // Crear sesion
            let cuotaRecuperacionFloat = Float(cuota_recuperacionText.text!)
            
            let newSesion:Sesion = Sesion(usuarioID: id!, numero_sesion: 1, cuota_recuperacion: cuotaRecuperacionFloat!, tanatologoUID: cetacUserUID, motivo: motivoText.text!, tipo_servicio: tipo_servicioText.text!, tipo_intervencion: tipo_intervencionText.text!, herramienta: herramientaText.text!, evaluacion_sesion: evaluacion_sesionText.text!, fecha: Timestamp())
            
            sesionControlador.insertSesion(nuevaSesion: newSesion){ (result) in
                switch result{
                case .success(let retorno):self.displayExito(title: retorno, detalle: "Se insertaron los datos correctamente")
                case .failure(let error):self.displayError(error, title: "No se guardó la sesión")
                }
            }
            // End crear sesion
            }
    }
    
    func validateData() -> Error? {
        if (nombreText.text!.isEmpty) || (paternoText.text!.isEmpty) || (maternoText.text!.isEmpty) || (religionText.text!.isEmpty) || (procedenciaText.text!.isEmpty) || (domicilioText.text!.isEmpty) || (tel_casaText.text!.isEmpty) || (celularText.text!.isEmpty) || (estado_civilText.text!.isEmpty) || (fecha_nacimientoText.text!.isEmpty) || (sexoText.text!.isEmpty) || (referido_porText.text!.isEmpty) || (problemaText.text!.isEmpty) || (indicador_actitudinalText.text!.isEmpty) || (ekrText.text!.isEmpty) || (numeroHijosText.text!.isEmpty) {
            return CustomError.emptyUserFields
        }
        if isNumber(numeroHijosText.text!) == false{
            return CustomError.emptyHijoFields
        }
        if (motivoText.text!.isEmpty || tipo_servicioText.text!.isEmpty || tipo_intervencionText.text!.isEmpty || herramientaText.text!.isEmpty || evaluacion_sesionText.text!.isEmpty || cuota_recuperacionText.text!.isEmpty){
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
    
    func isNumber(_ numero:String) -> Bool{
        let floatNumberRegex = "^\\d*\\.?\\d*$"
        let floatNumberTest = NSPredicate(format: "SELF MATCHES %@", floatNumberRegex)
        return floatNumberTest.evaluate(with: numero)
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
    
    // Date picker view -------------------------------
    func createDatePickerView() {
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

extension EncuadreViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
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
            return self.generos.count
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
            return self.generos[row]
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
            sexoText.text! = generos[row]
        default:
            return
        }
    }
}

extension EncuadreViewController : ToolbarPickerViewDelegate{
    func didTapDone() {
        self.view.endEditing(true)
    }
}
