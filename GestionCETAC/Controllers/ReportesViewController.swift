//
//  ReportesViewController.swift
//  GestionCETAC
//
//  Created by Diógenes Grajales Corona on 06/10/21.
//

import UIKit
import Firebase

class ReportesViewController: UIViewController {
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
    @IBOutlet var deleteButton: UIBarButtonItem!
    
    var currentUser:Usuario?
    var firstSesion:Sesion?
    var editingMode:Bool = false
    let cetacUserRol:String = UserDefaults.standard.string(forKey: "currentCetacUserRol")!
    let cetacUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    var fechaNacimientoDate:Date?
    var edad:Int?
    
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
        
        usuarioControlador.getUser(userID: 1){ (result) in
            switch result{
            case .success(let usuariod): self.setUserInfo(usuariod)
            case .failure(let error):self.displayError(error, title: "No se pudo obtener el usuario")
            }
            
        }
        
        //usuarioText.text = "Hola"
        
        sesionControlador.getSesionNumber(userID: 2, sesionNumber: 1){ (result) in
            switch result{
            case .success(let firstSesion):self.setUserData(firstSesion)
            case .failure(let error):self.displayError(error, title: "No se pudo obtener la primera sesión del usuario")
            }
        }

        // Do any additional setup after loading the view.
    }
    
    func setUserInfo(_ currentUser:Usuario){
        self.currentUser = currentUser
        expedienteID.text = String(currentUser.id)
        usuarioText.text = currentUser.nombre
    }
    
    func setUserData(_ firstSesion:Sesion){
        self.firstSesion = firstSesion
        // Datos de usuario
        sesionID.text = String(firstSesion.numero_sesion)
        
    
        //usuarioText.text = "Hola"
        
        let fecha_sesion:Date = firstSesion.fecha.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        fechaText.text = dateFormatter.string(from: fecha_sesion)
        
        
        motivoText.text = firstSesion.motivo
        servicioText.text = firstSesion.tipo_servicio
        intervencionText.text = firstSesion.tipo_intervencion
        herramientaText.text = firstSesion.herramienta
        evaluacionText.text = firstSesion.evaluacion_sesion
        cuotaText.text = firstSesion.cuota_recuperacion.description
        
        
    }
    
    func setStateTextFields(){
        if editingMode == false{
            // Unable text fields and text views
            expedienteID.isUserInteractionEnabled = false
            usuarioText.isUserInteractionEnabled = false
            usuarioText.isUserInteractionEnabled = false
            
            sesionID.isUserInteractionEnabled = false
            fechaText.isUserInteractionEnabled = false
    
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
            
            expedienteID.isUserInteractionEnabled = true
            usuarioText.isUserInteractionEnabled = true
            usuarioText.isUserInteractionEnabled = true
            
            sesionID.isUserInteractionEnabled = true
            fechaText.isUserInteractionEnabled = true
    
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
        }
        else{
            editingMode = false
            setStateTextFields()
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReportesViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
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

extension ReportesViewController : ToolbarPickerViewDelegate{
    func didTapDone() {
        self.view.endEditing(true)
    }
}

