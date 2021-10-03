//
//  HomeGestionCETACViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 27/09/21.
//

import UIKit
import Firebase
class HomeGestionCETACViewController: UIViewController {
    
    var currentUserController = cetacUserController()
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.tabBar.isHidden = true
        let UID = UserDefaults.standard.string(forKey: "currentCetacUserUID") ?? "Usuario desconocido"
        print(UID)
        currentUserController.getUserInfo{ (result) in
            switch result{
            case .success(let user):self.setName(username: user.nombre)
            case .failure(let error): print(error.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
    }
    func setName(username : String) {
        self.welcomeLabel.text! = "¡Bienvenido \(username)!"
    }
}
