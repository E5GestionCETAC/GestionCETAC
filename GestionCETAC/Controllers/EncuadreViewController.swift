//
//  EncuadreViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 29/09/21.
//

import UIKit
import Firebase

class EncuadreViewController: UIViewController {

    let datePicker = UIDatePicker()

    var userController = usuarioController()
    var currentUserController = cetacUserController()
    
    var id:Int?
    var cetacUserID:String?
    var fechaNacimientoDate:Date?
    var edad:Int?
    
    // Datos de usuario--------------------------------
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var paternoText: UITextField!
    @IBOutlet weak var maternoField: UITextField!
    @IBOutlet weak var religionText: UITextField!
    @IBOutlet weak var ocupacionText: UITextField!
    @IBOutlet weak var procedenciaText: UITextField!
    @IBOutlet weak var domicilioText: UITextField!
    @IBOutlet weak var tel_casaText: UITextField!
    @IBOutlet weak var celularText: UITextField!
    @IBOutlet weak var estado_civilText: UITextField!
    @IBOutlet weak var fecha_nacimientoText: UITextField!
    @IBOutlet weak var sexoText: UITextField!
    @IBOutlet weak var referido_porText: UITextField!
    @IBOutlet weak var problemaText: UITextField!
    @IBOutlet weak var indicador_actitudinalText: UITextField!
    @IBOutlet weak var ekrText: UITextField!
    // End Datos de usuarios---------------------------
    
    // Datos de sesion---------------------------------
    @IBOutlet weak var motivoText: UITextField!
    @IBOutlet weak var tipo_servicioText: UITextField!
    @IBOutlet weak var tipo_intervencionText: UITextField!
    @IBOutlet weak var herramientaText: UITextField!
    @IBOutlet weak var evaluacion_sesionText: UITextField!
    @IBOutlet weak var cuota_recuperacionText: UITextField!
    // End Datos de sesion-----------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePickerView()
        currentUserController.getUserInfo{ (result) in
            switch result{
            case .success(let user):self.cetacUserID = user.uid
            case .failure(let error): print(error.localizedDescription)
            }
        }
        self.userController.getLastID{ (result) in
            switch result{
            case .success(let lastID): self.id = lastID + 1
            case .failure(let error): print(error.localizedDescription)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func encuadre(_ sender: Any) {
        let error = validateData()
        if let error = error {
            print(error)
        }else{
            let fechaNacimientoTimestamp = Timestamp(date: fechaNacimientoDate!)
            // Calcular edad---------------------------
            let now = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: fechaNacimientoDate!, to: now)
            self.edad = ageComponents.year!
            // End Calcular edad-----------------------
            let newUser:Usuario = Usuario(id: self.id!, edad: self.edad!, nombre: self.nombreText.text!, apellido_paterno: self.paternoText.text!, apellido_materno: self.maternoField.text!, ocupacion: self.ocupacionText.text!, religion: self.religionText.text!, tel_casa: self.tel_casaText.text!, celular: self.celularText.text!, problema: self.problemaText.text!, estado_civil: self.estado_civilText.text!, sexo: self.sexoText.text!, ekr: self.ekrText.text!, indicador_actitudinal: self.indicador_actitudinalText.text!, domicilio: self.domicilioText.text!, procedencia: self.procedenciaText.text!, referido_por: self.referido_porText.text!, cetacUserID: self.cetacUserID!, fecha_nacimiento: fechaNacimientoTimestamp)
            
            userController.insertUsuario(nuevoUsuario: newUser){(result) in
                switch result{
                case .success(let retorno):print(retorno)
                case.failure(let error):print(error)
                }
            }
        }
    }
    
    func validateData() -> String? {
        if (nombreText.text!.isEmpty) || (paternoText.text!.isEmpty) || (maternoField.text!.isEmpty) || (religionText.text!.isEmpty) || (procedenciaText.text!.isEmpty) || (domicilioText.text!.isEmpty) || (tel_casaText.text!.isEmpty) || (celularText.text!.isEmpty) || (estado_civilText.text!.isEmpty) || (fecha_nacimientoText.text!.isEmpty) || (sexoText.text!.isEmpty) || (referido_porText.text!.isEmpty) || (problemaText.text!.isEmpty) || (indicador_actitudinalText.text!.isEmpty) || (ekrText.text!.isEmpty) {
            return "Los datos del usuario no pueden estar vacíos"
        }
        if (motivoText.text!.isEmpty || tipo_servicioText.text!.isEmpty || tipo_intervencionText.text!.isEmpty || herramientaText.text!.isEmpty || evaluacion_sesionText.text!.isEmpty || cuota_recuperacionText.text!.isEmpty){
            return "Los datos de la sesión no pueden estar vacíos"
        }
        return nil
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
