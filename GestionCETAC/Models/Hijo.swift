//
//  Hijo.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 29/09/21.
//

import Foundation
import Firebase

struct Hijo {
    let documentID,sexo:String
    let id,edad:Int
    
    init(id:Int, edad:Int, sexo:String) {
        self.documentID = "0"
        self.id = id
        self.sexo = sexo
        self.edad = edad
    }
    init(id:Int, edad:Int, sexo:String, documentID:String) {
        self.documentID = documentID
        self.id = id
        self.sexo = sexo
        self.edad = edad
    }
    init(aDoc : DocumentSnapshot) {
        self.documentID = aDoc.documentID
        self.id = aDoc.get("id") as? Int ?? 0
        self.sexo = aDoc.get("sexo") as? String ?? ""
        self.edad = aDoc.get("edad") as? Int ?? 0
    }
}
typealias Hijos = [Hijo]
