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
    var sesiones = [Sesion]()
    let currentCetacUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    let currentCetacUserRol:String = UserDefaults.standard.string(forKey: "currentCetacUserRol")!

    @IBOutlet weak var addButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // Do any additional setup after loading the view.
        if currentCetacUserRol == "Soporte Admon"{
            self.addButton.isEnabled = false
            self.addButton.tintColor = UIColor.clear
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
        return sesiones.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sesionCell", for: indexPath) as! SesionInfoCollectionViewCell
        cell.numeroSesionText.text = String(sesiones[indexPath.row].numero_sesion)
        cell.nombreSesionText.text = String(sesiones[indexPath.row].usuarioID)
        
        let fechaDate:Date = sesiones[indexPath.row].fecha.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        cell.fechaSesionText.text = dateFormatter.string(from: fechaDate)
        cell.motivoSesionText.text = sesiones[indexPath.row].motivo
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
