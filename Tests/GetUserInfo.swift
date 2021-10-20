//
//  GetUserInfo.swift
//  Tests
//
//  Created by Agustín Abreu on 20/10/21.
//

import XCTest
@testable import GestionCETAC
class GetUserInfo: XCTestCase {

    var expec = XCTestExpectation()
    let controlador = usuarioController()
    
    override func setUpWithError() throws {
        self.expec = expectation(description: "Test")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // Se espera que se recupere el mismo usuario de la base de datos
    func testExample1() throws {
        let userUID = "3LPCf9J9oWau1UCPyjSC"
        controlador.getUser(userID: 7){ (result) in
            switch result{
            case .success(let user):XCTAssertEqual(user.usuarioID, userUID)
            case .failure(let error):XCTAssertNil(error)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }
    
    // Se espera que el usuario recuperado NO sea igual al esperado
    func testExample2() throws {
        let userUID = "3LPCf9J9oWau1UCPyjSC"
        controlador.getUser(userID: 8){ (result) in
            switch result{
            case .success(let user):XCTAssertNotEqual(user.usuarioID, userUID)
            case .failure(let error):XCTAssertNil(error)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }
    
    // Se espera que NO se encuentre un usuario en la base de datos
    func testExample3() throws {
        let userUID = ""
        controlador.getUser(userID: 30){ (result) in
            switch result{
            case .success(let user):XCTAssertNotEqual(user.usuarioID, userUID)
            case .failure(let error):XCTAssertNotNil(error)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }

}
