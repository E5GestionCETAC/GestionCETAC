//
//  Hijo.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 29/09/21.
//

import Foundation
import Firebase

struct Hijo {
    let sexo:String
    let id,edad:Int
    let fecha_nacimiento:Timestamp
    
    init() {
        self.sexo = ""
        self.id = 1
        self.edad = 1
        self.fecha_nacimiento = Timestamp()
    }
    
    init(id:Int, sexo:String, edad:Int, fecha_nacimiento : Timestamp) {
        self.id = id
        self.sexo = sexo
        self.fecha_nacimiento = fecha_nacimiento
        self.edad = edad
    }
    
    init(aDoc : DocumentSnapshot) {
        self.id = aDoc.get("id") as? Int ?? 0
        self.sexo = aDoc.get("sexo") as? String ?? ""
        self.fecha_nacimiento = aDoc.get("fecha_nacimiento") as? Timestamp ?? Timestamp()
        self.edad = aDoc.get("edad") as? Int ?? 0
    }
}
typealias Hijos = [Hijo]
