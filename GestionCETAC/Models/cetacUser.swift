//
//  cetacUser.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 27/09/21.
//

import Foundation
import Firebase

struct cetacUser:Codable{
    let nombre, apellidos, uid, rol, email, docID, password :String
    init(nombre:String, apellidos :String, rol:String, email:String, password:String) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.uid = ""
        self.rol = rol
        self.email = email
        self.docID = "12345"
        self.password = password
    }
    init(aDoc : DocumentSnapshot) {
        self.uid = aDoc.get("uid") as? String ?? ""
        self.docID = aDoc.documentID
        self.nombre = aDoc.get("nombre") as? String ?? ""
        self.apellidos = aDoc.get("apellidos") as? String ?? ""
        self.rol = aDoc.get("rol") as? String ?? ""
        self.email = aDoc.get("email") as? String ?? ""
        self.password = ""
    }
}
typealias CetacUsuarios = [cetacUser]
