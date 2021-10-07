//
//  MisReportesCollectionViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 06/10/21.
//

import UIKit
import Firebase
class MisReportesCollectionViewController: UICollectionViewController {

    var sesionControlador = sesionController()
    var usuarioControlador = usuarioController()
    var cetacUsuariosControlador = cetacUserController()
    var sesiones = [Sesion]()
    var usuarios = [Usuario]()
    var cetacUsuarios =  [cetacUser]()
    var usersDictionary : [Int:String] = [:]
    var cetacUsersDictionary : [String:String] = [:]
    let currentCetacUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    let currentCetacUserRol:String = UserDefaults.standard.string(forKey: "currentCetacUserRol")!
    
    override func viewDidAppear(_ animated: Bool) {
        if currentCetacUserRol == "Administrador" || currentCetacUserRol == "Soporte Admon"{
            self.usuarioControlador.fetchUsuarios{ (result) in
                switch result{
                case .success(let users):self.setSesionInfo(users)
                case .failure(let error):self.displayError(error, title: "No se obtuvieron los usuarios")
                }
            }
        }else if currentCetacUserRol == "Tanatólogo"{
            self.usuarioControlador.fetchUsuariosFromCetacUser{(result) in
                switch result{
                case .success(let users):self.setSesionInfo(users)
                case .failure(let error):self.displayError(error, title: "No se obtuvieron los usuarios")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentCetacUserRol == "Administrador" || currentCetacUserRol == "Soporte Admon"{
            self.usuarioControlador.fetchUsuarios{ (result) in
                switch result{
                case .success(let users):self.setSesionInfo(users)
                case .failure(let error):self.displayError(error, title: "No se obtuvieron los usuarios")
                }
            }
        }else if currentCetacUserRol == "Tanatólogo"{
            self.usuarioControlador.fetchUsuariosFromCetacUser{(result) in
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
        cetacUsuariosControlador.fetchCetacUsuarios{ (result) in
            switch result{
            case .success(let users):self.setCetacUsers(users)
            case .failure(let error):self.displayError(error, title: "No se obtuvieron los Usuarios de CETAC")
            }
        }

    }
    
    func setCetacUsers(_ cetacUsers : CetacUsuarios){
        for user in cetacUsers{
            self.cetacUsersDictionary[user.uid] = "\(user.nombre) \(user.apellidos)"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedItem = sender as? Usuario else {return}
        
        if segue.identifier == "reporteInfo"{
            guard let destinationVC = segue.destination as? ReportesInfoViewController else {return}
            destinationVC.currentUser = selectedItem
        }
    }
    
    // Collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sesiones.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reporteCell", for: indexPath) as! ReporteCollectionViewCell
        cell.usuarioIDText.text = "Expediente #" + String(sesiones[indexPath.row].usuarioID)
        cell.numeroSesionText.text = "Sesión " + String(sesiones[indexPath.row].numero_sesion)
        cell.nombreUsuarioText.text = usersDictionary[sesiones[indexPath.row].usuarioID]
        cell.motivoText.text = sesiones[indexPath.row].motivo
        cell.servicioText.text = sesiones[indexPath.row].tipo_servicio
        cell.intervencionText.text = sesiones[indexPath.row].tipo_intervencion
        cell.herramientaText.text = sesiones[indexPath.row].herramienta
        // Fecha
        let fechaDate:Date = sesiones[indexPath.row].fecha.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        // End Fecha
        cell.fechaText.text = dateFormatter.string(from: fechaDate)
        cell.nombreTanatologoText.text = cetacUsersDictionary[sesiones[indexPath.row].tanatologoUID]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSesion = sesiones[indexPath.row]
        self.performSegue(withIdentifier: "reporteInfo", sender: selectedSesion)
    }
    // End Collection view
}
