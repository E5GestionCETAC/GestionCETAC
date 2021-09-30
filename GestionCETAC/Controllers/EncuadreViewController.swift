//
//  EncuadreViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 29/09/21.
//

import UIKit
import Firebase

class EncuadreViewController: UIViewController {

    var userController = usuarioController()
    var currentUserController = cetacUserController()
    
    var id:Int?
    let edad = 0
    let nombre = "Agustina Cruz"
    let apellido_paterno = "Ramirez"
    let apellido_materno = "Jaramillo"
    let ocupacion = "Gerente IT"
    let religion = "Hinduismo"
    let tel_casa = "12345"
    let celular = "67890"
    let problema = "Amsiedad"
    let estado_civil = "Viuda"
    let sexo = "No binario"
    let ekr = "123456789"
    let indicador_actitudinal = "Personalidad multiple"
    let domicilio = "Av Escuela Militar 861"
    let procedencia = "Wakanda"
    let referido_por = "El Chapo"
    var cetacUserID:String?
    let fecha_nacimiento = Timestamp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserController.getUserInfo{ (result) in
            switch result{
            case .success(let user):self.setCetacUserID(currentUser: user)
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
    

    @IBAction func createUser(_ sender: Any) {
        let newUser:Usuario = Usuario(id: self.id!, edad: self.edad, nombre: self.nombre, apellido_paterno: self.apellido_paterno, apellido_materno: self.apellido_materno, ocupacion: self.ocupacion, religion: self.religion, tel_casa: self.tel_casa, celular: self.celular, problema: self.problema, estado_civil: self.estado_civil, sexo: self.sexo, ekr: self.ekr, indicador_actitudinal: self.indicador_actitudinal, domicilio: self.domicilio, procedencia: self.procedencia, referido_por: self.referido_por, cetacUserID: self.cetacUserID!, fecha_nacimiento: self.fecha_nacimiento)
        
        userController.insertUsuario(nuevoUsuario: newUser){(result) in
            switch result{
            case .success(let retorno):print(retorno)
            case.failure(let error):print(error)
            }
        }
    }
    
    func setCetacUserID(currentUser:cetacUser) {
        self.cetacUserID = currentUser.uid
    }
}
