//
//  MisSesionesCollectionViewController.swift
//  GestionCETAC
//
//  Created by user195142 on 10/4/21.
//

import UIKit
import Firebase

class MisSesionesCollectionViewController: UICollectionViewController {
    
    var sesionControlador = sesionController()
    var usuarioControlador = usuarioController()
    var sesiones = [Sesion]()
    var usuarios = [Usuario]()
    var usersDictionary : [Int:String] = [:]
    let currentCetacUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    let currentCetacUserRol:String = UserDefaults.standard.string(forKey: "currentCetacUserRol")!

    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidAppear(_ animated: Bool) {
        if currentCetacUserRol == "Soporte Admon"{
            self.addButton.isEnabled = false
            self.addButton.tintColor = UIColor.clear
        }
        if currentCetacUserRol == "Administrador" || currentCetacUserRol == "Soporte Admon"{
            self.usuarioControlador.fetchActiveUsuarios{ (result) in
                switch result{
                case .success(let users):self.setSesionInfo(users)
                case .failure(let error):self.displayError(error, title: "No se obtuvieron los usuarios")
                }
            }
        }else if currentCetacUserRol == "Tanatólogo"{
            self.usuarioControlador.fetchActiveUsuariosFromCetacUser{(result) in
                switch result{
                case .success(let users):self.setSesionInfo(users)
                case .failure(let error):self.displayError(error, title: "No se obtuvieron los usuarios")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentCetacUserRol == "Soporte Admon"{
            self.addButton.isEnabled = false
            self.addButton.tintColor = UIColor.clear
        }
        if currentCetacUserRol == "Administrador" || currentCetacUserRol == "Soporte Admon"{
            self.usuarioControlador.fetchAllUsuarios{ (result) in
                switch result{
                case .success(let users):self.setSesionInfo(users)
                case .failure(let error):self.displayError(error, title: "No se obtuvieron los usuarios")
                }
            }
        }else if currentCetacUserRol == "Tanatólogo"{
            self.usuarioControlador.fetchAllUsuariosFromCetacUser{(result) in
                switch result{
                case .success(let users):self.setSesionInfo(users)
                case .failure(let error):self.displayError(error, title: "No se obtuvieron los usuarios")
                }
            }
        }
    }
    
    func setSesionInfo(_ users:Usuarios){
        self.usuarios = users
        for user in users{
            usersDictionary[user.id] = "\(user.nombre) \(user.apellido_paterno) \(user.apellido_materno)"
        }
        if currentCetacUserRol == "Administrador" || currentCetacUserRol == "Soporte Admon"{
            self.sesionControlador.fetchSesiones{(result) in
                switch result{
                case .success(let sesiones): self.updateUI(with: sesiones)
                case .failure(let error): self.displayError(error, title: "No se pudieron obtener sesiones")
                }
            }
        }else if currentCetacUserRol == "Tanatólogo"{
            self.sesionControlador.fetchSesionesFromCetacUser{ (result) in
                switch result{
                case .success(let sesiones): self.updateUI(with: sesiones)
                case .failure(let error): self.displayError(error, title: "No se pudieron obtener sesiones")
                }
            }
        }
    }
    
    func updateUI(with sesiones:Sesiones){
        DispatchQueue.main.async {
            self.sesiones = sesiones
            self.collectionView.reloadData()
        }
    }
        
    func displayError(_ error: Error, title:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sesiones.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sesionCell", for: indexPath) as! SesionInfoCollectionViewCell
        
        if indexPath.row == 0{
            cell.numeroSesionText.text = "Número de sesión"
            cell.fechaSesionText.text = "Fecha de última sesión"
            cell.nombreSesionText.text = "Nombre del usuario"
            cell.motivoSesionText.text = "Motivo de sesión"
        }else{
            cell.numeroSesionText.text = String(sesiones[indexPath.row-1].numero_sesion)
            cell.nombreSesionText.text = usersDictionary[sesiones[indexPath.row-1].usuarioID]
            // Fecha
            let fechaDate:Date = sesiones[indexPath.row-1].fecha.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            // End Fecha
            cell.fechaSesionText.text = dateFormatter.string(from: fechaDate)
            cell.motivoSesionText.text = sesiones[indexPath.row-1].motivo
        }
        return cell
    }
}
