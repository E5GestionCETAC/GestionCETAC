//
//  GetCetacUserInfoTest.swift
//  Tests
//
//  Created by Agustín Abreu on 09/10/21.
//

import XCTest
@testable import GestionCETAC
class GetCetacUserInfoTest: XCTestCase {

    var expectedUser1:cetacUser?
    var expectedUser2:cetacUser?
    var expec = XCTestExpectation()
    let controlador = cetacUserController()
    
    override func setUpWithError() throws {
        self.expec = expectation(description: "Test")
        self.expectedUser1 = cetacUser(nombre: "Daniel", apellidos: "Cruz Péres", rol: "Tanatólogo", email: "daniel@test.com", password: "")
        self.expectedUser2 = cetacUser(nombre: "Daniel", apellidos: "Cruz", rol: "Pérez", email: "dan@test.com", password: "")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    // Se espera que se recupere el mismo usuario de la base de datos
    func testExample1() throws {
        let userUID = "9EMHacDKNZcLWjrHG30xMvqBUt03"
        controlador.getUserInfo(currentUserUID: userUID){ (result) in
            switch result{
            case .success(let user):XCTAssertEqual(user.email, self.expectedUser1!.email)
            case .failure(let error):XCTAssertNil(error)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }

    // Se espera que el usuario recuperado NO sea igual al esperado
    func testExample2() throws {
        let userUID = "9EMHacDKNZcLWjrHG30xMvqBUt03"
        controlador.getUserInfo(currentUserUID: userUID){ (result) in
            switch result{
            case .success(let user):XCTAssertNotEqual(user.email, self.expectedUser2!.email)
            case .failure(let error):XCTAssertNil(error)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }
    
    // Se espera que NO se encuentre un usuario en la base de datos
    func testExample3() throws {
        let userUID = ""
        controlador.getUserInfo(currentUserUID: userUID){ (result) in
            switch result{
            case .success(let user):XCTAssertNotEqual(user.email, self.expectedUser2!.email)
            case .failure(let error):XCTAssertNotNil(error)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }
    
}
