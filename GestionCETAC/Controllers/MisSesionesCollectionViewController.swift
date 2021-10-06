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
        if currentCetacUserRol == "Soporte Admon"{
            self.addButton.isEnabled = false
            self.addButton.tintColor = UIColor.clear
        }
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
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedItem = sender as? Sesion else {return}
        
        if segue.identifier == "sesionInfo"{
            guard let destinationVC = segue.destination as? InformacionUsuarioViewController else {return}
            destinationVC.currentUser = selectedItem
        }
    }
    */
    // Collection view configuration
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sesiones.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sesionCell", for: indexPath) as! SesionInfoCollectionViewCell
        cell.numeroSesionText.text = String(sesiones[indexPath.row].numero_sesion)
        cell.nombreSesionText.text = usersDictionary[sesiones[indexPath.row].usuarioID]
        // Fecha
        let fechaDate:Date = sesiones[indexPath.row].fecha.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        // End Fecha
        cell.fechaSesionText.text = dateFormatter.string(from: fechaDate)
        cell.motivoSesionText.text = sesiones[indexPath.row].motivo
        return cell
    }
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSesion = sesiones[indexPath.item]
        self.performSegue(withIdentifier: "sesionInfo", sender: selectedSesion)
    }
     */
    // End Collection view configuration
}
