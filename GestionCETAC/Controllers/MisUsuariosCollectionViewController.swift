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
            self.userController.fetchUsuarios{(result) in
                switch result{
                case .success(let usuarios): self.updateUI(with: usuarios)
                case .failure(let error): self.displayError(error, title: "No se pudieron obtener usuarios")
                }
            }
        }else if currentCetacUserRol == "Tanatólogo"{
            self.userController.fetchUsuariosFromCetacUser{ (result) in
                switch result{
                case .success(let usuarios): self.updateUI(with: usuarios)
                case .failure(let error): self.displayError(error, title: "No se pudieron obtener usuarios")
                }
            }
        }
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        /*self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
         */
        // Do any additional setup after loading the view.
        if currentCetacUserRol == "Soporte Admon"{
            self.addButton.isEnabled = false
            self.addButton.tintColor = UIColor.clear
        }
        if currentCetacUserRol == "Administrador" || currentCetacUserRol == "Soporte Admon"{
            self.userController.fetchUsuarios{(result) in
                switch result{
                case .success(let usuarios): self.updateUI(with: usuarios)
                case .failure(let error): self.displayError(error, title: "No se pudieron obtener usuarios")
                }
            }
        }else if currentCetacUserRol == "Tanatólogo"{
            self.userController.fetchUsuariosFromCetacUser{ (result) in
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
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
        
        cell.userLabel.text = users[indexPath.row].nombre
        // Configure the cell
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedItem = sender as? Usuario else {return}
        
        if segue.identifier == "userInfo"{
            guard let destinationVC = segue.destination as? InformacionUsuarioViewController else {return}
            destinationVC.currentUser = selectedItem
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.item]
        self.performSegue(withIdentifier: "userInfo", sender: selectedUser)
    }

}
