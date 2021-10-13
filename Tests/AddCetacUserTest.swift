//
//  AddCetacUserTest.swift
//  Tests
//
//  Created by Agustín Abreu on 09/10/21.
//

import XCTest
@testable import GestionCETAC
class AddCetacUserTest: XCTestCase {

    // Los Administradores si pueden añadir más miemrbos de CETAC
    func testExample1() throws {
        let VC = HomeGestionCETACViewController()
        let result = VC.canAddCETACUsers(rol: "Administrador")
        XCTAssertTrue(result)
    }

    // Los Tanatólogos no pueden añadir más miembros de CETAC
    func testExample2() throws {
        let VC = HomeGestionCETACViewController()
        let result = VC.canAddCETACUsers(rol: "Tanatólogo")
        XCTAssertFalse(result)
    }
    
    // Los Soporte Admon no pueden añadir más miembros de CETAC
    func testExample3() throws {
        let VC = HomeGestionCETACViewController()
        let result = VC.canAddCETACUsers(rol: "Soporte Admon")
        XCTAssertFalse(result)
    }
    
    // Los Usuarios no pueden añadir más miembros de CETAC
    func testExample4() throws {
        let VC = HomeGestionCETACViewController()
        let result = VC.canAddCETACUsers(rol: "Usuario")
        XCTAssertFalse(result)
    }
}
