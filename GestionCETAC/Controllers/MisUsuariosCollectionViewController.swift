//
//  MisUsuariosCollectionViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 01/10/21.
//

import UIKit

class MisUsuariosCollectionViewController: UICollectionViewController {
    
    // Images name
    let imagesName:[String] = ["caballo","aguila","antilope","arana","cerdo","cheeta","conejo","dalmata","delfin","elefante","gato","gato2","gorila","guacamaya","jirafa","kanguro","labrador","lobo","mariposa","mono","murcielago","orca","paloma","panda","panda2","perezoso","perro","pez","pinguino","pinguino2","pug","raton","sabueso","serpiente","tigre_blanco","tigre","zebra","zorro"]
    // End Images name
    
    var userController = usuarioController()
    var users = [Usuario]()
    let currentCetacUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    let currentCetacUserRol:String = UserDefaults.standard.string(forKey: "currentCetacUserRol")!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentCetacUserRol == "Soporte Admon"{
            self.addButton.isEnabled = false
            self.addButton.tintColor = UIColor.clear
        }
        if currentCetacUserRol == "Administrador" || currentCetacUserRol == "Soporte Admon"{
            self.userController.fetchActiveUsuarios{(result) in
                switch result{
                case .success(let usuarios): self.updateUI(with: usuarios)
                case .failure(let error): self.displayError(error, title: "No se pudieron obtener usuarios")
                }
            }
        }else if currentCetacUserRol == "Tanatólogo"{
            self.userController.fetchActiveUsuariosFromCetacUser{ (result) in
                switch result{
                case .success(let usuarios): self.updateUI(with: usuarios)
                case .failure(let error): self.displayError(error, title: "No se pudieron obtener usuarios")
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
            self.userController.fetchActiveUsuarios{(result) in
                switch result{
                case .success(let usuarios): self.updateUI(with: usuarios)
                case .failure(let error): self.displayError(error, title: "No se pudieron obtener usuarios")
                }
            }
        }else if currentCetacUserRol == "Tanatólogo"{
            self.userController.fetchActiveUsuariosFromCetacUser{ (result) in
                switch result{
                case .success(let usuarios): self.updateUI(with: usuarios)
                case .failure(let error): self.displayError(error, title: "No se pudieron obtener usuarios")
                }
            }
        }
    }
    
    func updateUI(with usuarios:Usuarios){
        DispatchQueue.main.async {
            self.users = usuarios
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
        
        if segue.identifier == "userInfo"{
            guard let destinationVC = segue.destination as? InformacionUsuarioViewController else {return}
            destinationVC.currentUser = selectedItem
        }
    }
    // Collection view configuration
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UsuarioCollectionViewCell
        let laps = (ceil(Double(indexPath.row)/Double(imagesName.count))) - 1
        if indexPath.row > imagesName.count{
            let index = (indexPath.row - (Int(laps) * imagesName.count)) - 1
            cell.userImageView.image = UIImage(named: imagesName[index])
        }else{
            cell.userImageView.image = UIImage(named: imagesName[indexPath.row])
        }
        cell.userLabel.text = users[indexPath.row].nombre + " " + users[indexPath.row].apellido_paterno
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.item]
        self.performSegue(withIdentifier: "userInfo", sender: selectedUser)
    }
    // End Configuration view configuration
}
