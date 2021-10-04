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
        currentUserController.getUserInfo{ (result) in
            switch result{
            case .success(let user):self.setCurrentUserInfo(user)
            case .failure(let error): self.displayError(error, title: "No se pudo obtener datos del usuario")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func setCurrentUserInfo(_ currentUser : cetacUser) {
        self.welcomeLabel.text! = "¡Bienvenido \(currentUser.rol) \(currentUser.nombre)!"
        UserDefaults.standard.set(currentUser.rol, forKey: "currentCetacUserRol")
    }
    
    func displayError(_ error: Error, title:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToHome( _ segue: UIStoryboardSegue) {}
}
