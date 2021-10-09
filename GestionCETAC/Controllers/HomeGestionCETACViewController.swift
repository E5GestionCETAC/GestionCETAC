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
    @IBOutlet weak var addButton: UIBarButtonItem!
    let currentCetacUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        addButton.isEnabled = false
        addButton.tintColor = UIColor.clear
        currentUserController.getUserInfo(currentUserUID: self.currentCetacUserUID){ (result) in
            switch result{
            case .success(let user):self.setCurrentUserInfo(user)
            case .failure(let error): self.displayError(error, title: "No se pudo obtener datos del usuario")
            }
        }
    }
    
    func setCurrentUserInfo(_ currentUser : cetacUser) {
        self.welcomeLabel.text! = "¡Bienvenido \(currentUser.rol) \(currentUser.nombre)!"
        UserDefaults.standard.set(currentUser.rol, forKey: "currentCetacUserRol")
        if currentUser.rol == "Administrador"{
            addButton.tintColor = .systemBlue
            addButton.isEnabled = true
            
        }
    }
    
    func displayError(_ error: Error, title:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func unwindToHome(segue : UIStoryboardSegue){}
}
