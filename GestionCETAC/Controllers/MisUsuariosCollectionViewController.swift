//
//  MisUsuariosCollectionViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 01/10/21.
//

import UIKit

class MisUsuariosCollectionViewController: UICollectionViewController {
    
    let imagesName:[String] = ["caballo","aguila","antilope","arana","cerdo","cheeta","conejo","dalmata","delfin","elefante","gato","gato2","gorila","guacamaya","jirafa","kanguro","labrador","lobo","mariposa","mono","murcielago","orca","paloma","panda","panda2","perezoso","perro","pez","pinguino","pinguino2","pug","raton","sabueso","serpiente","tigre_blanco","tigre","zebra","zorro"]

    var userController = usuarioController()
    var currentUserController = cetacUserController()
    var users = [Usuario]()
    var cetacUID:String?
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentUserController.getUserInfo{ (result) in
            switch result{
            case .success(let user):self.getUsuarios(cetacUserUID: user.uid)
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    */
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        /*self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
         */
        // Do any additional setup after loading the view.
        currentUserController.getUserInfo{ (result) in
            switch result{
            case .success(let user):self.getUsuarios(cetacUserUID: user.uid)
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    func getUsuarios(cetacUserUID : String){
        self.userController.fetchUsuariosFromCetacUser(cetacUID: cetacUserUID){ (result) in
            switch result{
            case .success(let usuarios): self.updateUI(with: usuarios)
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    func updateUI(with usuarios:Usuarios){
        DispatchQueue.main.async {
            self.users = usuarios
            self.collectionView.reloadData()
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
        cell.userImageView.image = UIImage(named: imagesName[Int.random(in: 0..<imagesName.count)])
        cell.userLabel.text = users[indexPath.row].nombre
        //cell.user = users[indexPath.row]
        // Configure the cell
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
