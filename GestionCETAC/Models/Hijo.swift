//
//  Hijo.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 29/09/21.
//

import Foundation
import Firebase

struct Hijo {
    let nombre,sexo:String
    let edad:Int
    
    init(sexo:String, edad:Int, nombre:String) {
        self.sexo = sexo
        self.edad = edad
        self.nombre = nombre
    }
    
    init(aDoc : DocumentSnapshot) {
        self.sexo = aDoc.get("sexo") as? String ?? ""
        self.edad = aDoc.get("edad") as? Int ?? 0
        self.nombre = aDoc.get("nombre") as? String ?? ""
    }
}
typealias Hijos = [Hijo]
