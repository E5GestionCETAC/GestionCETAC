//
//  ValidateEmailTest.swift
//  Tests
//
//  Created by Agustín Abreu on 09/10/21.
//

import XCTest
@testable import GestionCETAC
class ValidateEmailTest: XCTestCase {

    // Esta direccion de correo es invalida
    func testExample1() throws {
        let VC = LoginiViewController()
        let result = VC.isValidEmail("agus abreu")
        XCTAssertFalse(result)
    }
    
    // Esta direccion de correo es invalida
    func testExample2() throws {
        let VC = LoginiViewController()
        let result = VC.isValidEmail("agus@abreu")
        XCTAssertFalse(result)
    }
    
    // Esta direccion de correo es invalida
    func testExample3() throws {
        let VC = LoginiViewController()
        let result = VC.isValidEmail("agus@abreumx")
        XCTAssertFalse(result)
    }
    
    // Esta direccion de correo es invalida
    func testExample4() throws {
        let VC = LoginiViewController()
        let result = VC.isValidEmail("agus abreu.com")
        XCTAssertFalse(result)
    }
    
    // Esta direccion de correo es valida
    func testExample5() throws {
        let VC = LoginiViewController()
        let result = VC.isValidEmail("agus@abreu.com")
        XCTAssertTrue(result)
    }
}
