//
//  ValidateLogInTest.swift
//  Tests
//
//  Created by Agustín Abreu on 09/10/21.
//

import XCTest
import Firebase
@testable import GestionCETAC
class ValidateLogIn: XCTestCase {

    var expec = XCTestExpectation()
    
    override func setUpWithError() throws {
        self.expec = expectation(description: "Test")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    // Test with all the correct input from the user
    func testExample1() throws {
        let email = "daniel@test.com"
        let password = "Hello$88"
        let expectedUID = "9EMHacDKNZcLWjrHG30xMvqBUt03"
        Auth.auth().signIn(withEmail: email, password: password){ (result, error) in
            if error != nil{
                XCTAssertNil(error)
            }else{
                XCTAssertEqual(expectedUID, result!.user.uid)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }
    
    //Test with a non-existent email address
    func testExample2() throws {
        let email = "daniel@test.co"
        let password = "Hello$88"
        let expectedUID = "9EMHacDKNZcLWjrHG30xMvqBUt03"
        Auth.auth().signIn(withEmail: email, password: password){ (result, error) in
            if error != nil{
                XCTAssertNotNil(error)
            }else{
                XCTAssertEqual(expectedUID, result!.user.uid)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }
    
    //Test with a incorrect password
    func testExample3() throws {
        let email = "daniel@test.com"
        let password = "Hello$8"
        let expectedUID = "9EMHacDKNZcLWjrHG30xMvqBUt03"
        Auth.auth().signIn(withEmail: email, password: password){ (result, error) in
            if error != nil{
                XCTAssertNotNil(error)
            }else{
                XCTAssertEqual(expectedUID, result!.user.uid)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }
    
    
    //Test with an invalid UID
    func testExample4() throws {
        let email = "daniel@test.com"
        let password = "Hello$88"
        let expectedUID = "LfAwLvZWIBMterk5HCRIvIQOMrV2"
        Auth.auth().signIn(withEmail: email, password: password){ (result, error) in
            if error != nil{
                XCTAssertNil(error)
            }else{
                XCTAssertNotEqual(expectedUID, result!.user.uid)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }

}
