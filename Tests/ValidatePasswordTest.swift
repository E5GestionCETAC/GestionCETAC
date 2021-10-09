//
//  ValidatePasswordTest.swift
//  Tests
//
//  Created by Agustín Abreu on 09/10/21.
//

import XCTest
@testable import GestionCETAC
class ValidatePasswordTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample1() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("12345")
        XCTAssertFalse(result)
    }
    
    func testExample2() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("password")
        XCTAssertFalse(result)
    }

    func testExampl3() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("HolaMundo")
        XCTAssertFalse(result)
    }
    
    func testExample4() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("$PIDEr08")
        XCTAssertTrue(result)
    }
    
    func testExample5() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("Hello$88")
        XCTAssertTrue(result)
    }
    
    func testExample6() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("QQQQHello$88QQQQ")
        XCTAssertTrue(result)
    }
    func testExample7() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("OQQQQHello$88QQQQO")
        XCTAssertFalse(result)
    }
}
