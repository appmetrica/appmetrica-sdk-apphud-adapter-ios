
import XCTest
@testable import AppMetricaApphudObjCWrapper

final class ApphudInitializerTests: XCTestCase {
    
    var initializerMock: ApphudInitializerMock!
    private let apiKey = "test_api_key"
    private let userID = "user_id"
    private let deviceID = "device_id"
    private let observerMode = true
    
    override func setUp() {
        self.initializerMock = ApphudInitializerMock()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInvokeApphudViaObjcExtensionMethod() {
        let startExpectation = XCTestExpectation(description: "Should activate Apphud")
        self.initializerMock.expectation = startExpectation
        
        ApphudManager.shared.setApphudInitializerImpl(apphudInitializer: self.initializerMock)
        
        self.initializerMock.activateApphud(apiKey: self.apiKey,
                                           userID: self.userID,
                                           deviceID: self.deviceID,
                                           observerMode: self.observerMode)
        
        wait(for: [startExpectation], timeout: 1.0)
        
        XCTAssertEqual(self.apiKey, initializerMock.apiKey, "Should activate with valid api key")
        XCTAssertEqual(self.userID, initializerMock.userID, "Should activate with valid user ID")
        XCTAssertEqual(self.deviceID, initializerMock.deviceID, "Should activate with valid device ID")
        XCTAssertEqual(self.observerMode, initializerMock.observerMode, "Should activate with valid observer mode")
    }
}
