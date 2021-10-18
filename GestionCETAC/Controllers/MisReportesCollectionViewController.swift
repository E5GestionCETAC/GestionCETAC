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
    /*
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
    */
    override func viewDidLoad() {
        super.viewDidLoad()
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
        for usuario in usuarios{
            self.sesionControlador.getLastSesion(userID: usuario.id) {(result) in
                switch result{
                case .success(let sesion): self.addSesion(sesion)
                case .failure(let error): self.displayError(error, title: "No se pudo obtener la sesion")
                }
            }
        }
    }
    
    func addSesion(_ sesion:Sesion){
        self.sesiones.insert(sesion, at: 0)
        if sesiones.count == usuarios.count{
            self.updateUI(with: self.sesiones)
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
        
        if segue.identifier == "filtroSesion"{
            guard let destinationVC = segue.destination as? FiltroSesionesViewController else {return}
            destinationVC.selectedUser = selectedItem
        }
    }
    
    // Collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sesiones.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reporteCell", for: indexPath) as! ReporteCollectionViewCell
        if indexPath.row == 0{
            cell.sesionesAcumuladasText.text = "Total sesiones"
            cell.nombreUsuarioText.text = "Nombre del usuario"
            cell.fechaText.text = "Fecha de última sesión"
            cell.nombreTanatologoText.text = "Tanatólogo"
        }else{
            cell.sesionesAcumuladasText.text = String(sesiones[indexPath.row-1].numero_sesion)
            cell.nombreUsuarioText.text = usersDictionary[sesiones[indexPath.row-1].usuarioID]
            // Fecha
            let fechaDate:Date = sesiones[indexPath.row-1].fecha.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            // End Fecha
            cell.fechaText.text = dateFormatter.string(from: fechaDate)
            cell.nombreTanatologoText.text = cetacUsersDictionary[sesiones[indexPath.row-1].tanatologoUID]
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0{
            let selectedUser = usuarios[indexPath.row-1]
            self.performSegue(withIdentifier: "filtroSesion", sender: selectedUser)
        }
    }
    // End Collection view
}
