//
//  User.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 29/09/21.
//

import Foundation
import Firebase

struct Usuario {
    let id, edad, numeroHijos : Int
    let usuarioID, nombre, apellido_paterno, apellido_materno, ocupacion, religion, tel_casa, celular, estado_civil, problema, sexo, ekr, indicador_actitudinal,domicilio, procedencia, referido_por, cetacUserID : String
    let fecha_nacimiento : Timestamp
    let activo:Bool
    var hijos:[Hijo]?
    
    init(id : Int, edad : Int, nombre : String, apellido_paterno : String, apellido_materno : String, ocupacion : String, religion : String, tel_casa : String, celular : String, problema : String, estado_civil : String, sexo : String, ekr : String, indicador_actitudinal : String, domicilio : String, procedencia : String, referido_por : String, cetacUserID: String, fecha_nacimiento:Timestamp, activo:Bool, numeroHijos:Int) {
        self.usuarioID = "0"
        self.id = id
        self.edad = edad
        self.nombre = nombre
        self.apellido_paterno = apellido_paterno
        self.apellido_materno = apellido_materno
        self.ocupacion = ocupacion
        self.religion = religion
        self.tel_casa = tel_casa
        self.celular = celular
        self.problema = problema
        self.estado_civil = estado_civil
        self.sexo = sexo
        self.ekr = ekr
        self.indicador_actitudinal = indicador_actitudinal
        self.domicilio = domicilio
        self.procedencia = procedencia
        self.referido_por = referido_por
        self.cetacUserID = cetacUserID
        self.fecha_nacimiento = fecha_nacimiento
        self.activo = true
        self.numeroHijos = numeroHijos
        self.hijos = nil
    }
    
    init(usuarioID:String, id : Int, edad : Int, nombre : String, apellido_paterno : String, apellido_materno : String, ocupacion : String, religion : String, tel_casa : String, celular : String, problema : String, estado_civil : String, sexo : String, ekr : String, indicador_actitudinal : String, domicilio : String, procedencia : String, referido_por : String, cetacUserID: String, fecha_nacimiento:Timestamp, activo:Bool, numeroHijos:Int) {
        self.usuarioID = usuarioID
        self.id = id
        self.edad = edad
        self.nombre = nombre
        self.apellido_paterno = apellido_paterno
        self.apellido_materno = apellido_materno
        self.ocupacion = ocupacion
        self.religion = religion
        self.tel_casa = tel_casa
        self.celular = celular
        self.problema = problema
        self.estado_civil = estado_civil
        self.sexo = sexo
        self.ekr = ekr
        self.indicador_actitudinal = indicador_actitudinal
        self.domicilio = domicilio
        self.procedencia = procedencia
        self.referido_por = referido_por
        self.cetacUserID = cetacUserID
        self.fecha_nacimiento = fecha_nacimiento
        self.activo = activo
        self.numeroHijos = numeroHijos
        self.hijos = nil
    }
    
    init(aDoc : DocumentSnapshot) {
        self.usuarioID = aDoc.documentID
        self.id = aDoc.get("id") as? Int ?? 0
        self.edad = aDoc.get("edad") as? Int ?? 0
        self.nombre = aDoc.get("nombre") as? String ?? ""
        self.apellido_paterno = aDoc.get("apellido_paterno") as? String ?? ""
        self.apellido_materno = aDoc.get("apellido_materno") as? String ?? ""
        self.ocupacion = aDoc.get("ocupacion") as? String ?? ""
        self.religion = aDoc.get("religion") as? String ?? ""
        self.tel_casa = aDoc.get("tel_casa") as? String ?? ""
        self.celular = aDoc.get("celular") as? String ?? ""
        self.problema = aDoc.get("problema") as? String ?? ""
        self.estado_civil = aDoc.get("estado_civil") as? String ?? ""
        self.sexo = aDoc.get("sexo") as? String ?? ""
        self.ekr = aDoc.get("ekr") as? String ?? ""
        self.indicador_actitudinal = aDoc.get("indicador_actitudinal") as? String ?? ""
        self.domicilio = aDoc.get("domicilio") as? String ?? ""
        self.procedencia = aDoc.get("procedencia") as? String ?? ""
        self.referido_por = aDoc.get("referido_por") as? String ?? ""
        self.cetacUserID = aDoc.get("cetacUserID") as? String ?? ""
        self.fecha_nacimiento = aDoc.get("fecha_nacimiento") as? Timestamp ?? Timestamp()
        self.activo = aDoc.get("activo") as? Bool ?? true
        self.numeroHijos = aDoc.get("numeroHijos") as? Int ?? 0
        self.hijos = nil
    }
    
    mutating func addHijos(hijos: [Hijo]) {
        self.hijos = hijos
    }
}
 typealias Usuarios = [Usuario]
