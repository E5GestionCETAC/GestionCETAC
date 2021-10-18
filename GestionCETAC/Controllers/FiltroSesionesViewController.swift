//
//  FiltroSesionesViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 13/10/21.
//

import UIKit

class FiltroSesionesViewController: UIViewController {
    
    //Controladores
    var usuarioControlador = usuarioController()
    var sesionControlador = sesionController()
    var cetacUsuarioControlador = cetacUserController()
    //End Controladores
    
    // Outlets
    @IBOutlet weak var nombreUsuarioText: UILabel!
    @IBOutlet weak var expedienteText: UILabel!
    @IBOutlet weak var nombreTanatologoText: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    // End Outlets
    
    // Otra variables
    var sesiones = [Sesion]()
    var selectedUser:Usuario?
    // End otras variables
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        nombreUsuarioText.text = "Nombre del usuario: \(selectedUser!.nombre) \(selectedUser!.apellido_paterno) \(selectedUser!.apellido_materno)"
        expedienteText.text = "Numero de expediente: \(selectedUser!.id)"
        cetacUsuarioControlador.getUserInfo(currentUserUID: selectedUser!.cetacUserID){ (result) in
            switch result{
            case .success(let selectedCetacUser): self.setTanatologoName(selectedCetacUser.nombre)
            case .failure(let error):self.displayError(error, title: "No se pudo obtener la información del tanatólogo")
            }
        }
        sesionControlador.fetchSesionesFromUser(userID: selectedUser!.id){(result) in
            switch result{
            case.success(let sesiones):self.updateUI(with: sesiones)
            case .failure(let error):self.displayError(error, title: "No se pudo obtener las sesiones")
            }
        }
    }
    
    func setTanatologoName(_ name:String){
        self.nombreTanatologoText.text = "Tanatologo: " + name
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
        guard let selectedItem = sender as? Sesion else {return}
        
        if segue.identifier == "sesionInfo"{
            guard let destinationVC = segue.destination as? ReportesInfoViewController else {return}
            destinationVC.currentSesion = selectedItem
        }
    }

}

extension FiltroSesionesViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sesiones.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtroSesion", for: indexPath) as! FiltroSesionCollectionViewCell

        if indexPath.row == 0{
            cell.numeroSesionText.text = "Sesion"
            cell.fechaText.text = "Fecha"
            cell.motivoText.text = "Motivo"
            cell.servicioText.text = "Servicio"
            cell.intervencionText.text = "Intervencion"
            cell.herramientaText.text = "Herramienta"
        }else{
            cell.numeroSesionText.text = String(sesiones[indexPath.row-1].numero_sesion)
            // Fecha
            let fechaDate:Date = sesiones[indexPath.row-1].fecha.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            // End Fecha
            cell.fechaText.text = dateFormatter.string(from: fechaDate)
            cell.motivoText.text = sesiones[indexPath.row-1].motivo
            cell.servicioText.text = sesiones[indexPath.row-1].tipo_servicio
            cell.intervencionText.text = sesiones[indexPath.row-1].tipo_intervencion
            cell.herramientaText.text = sesiones[indexPath.row-1].herramienta
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0{
            let selectedSesion = sesiones[indexPath.row-1]
            self.performSegue(withIdentifier: "sesionInfo", sender: selectedSesion)
        }
    }

}
