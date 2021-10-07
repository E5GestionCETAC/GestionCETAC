//
//  cetacUser.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 27/09/21.
//

import Foundation
import Firebase

struct cetacUser:Codable{
    let nombre, apellidos, uid, rol, email, docID :String
    init(nombre:String, apellidos :String, uid:String, rol:String, email:String) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.uid = uid
        self.rol = rol
        self.email = email
        self.docID = "12345"
    }
    init(aDoc : DocumentSnapshot) {
        self.uid = aDoc.get("uid") as? String ?? ""
        self.docID = aDoc.documentID
        self.nombre = aDoc.get("nombre") as? String ?? ""
        self.apellidos = aDoc.get("apellidos") as? String ?? ""
        self.rol = aDoc.get("rol") as? String ?? ""
        self.email = aDoc.get("email") as? String ?? ""
    }
}
typealias CetacUsuarios = [cetacUser]
