
import XCTest
@testable import AppMetricaApphudObjCWrapper

final class ApphudStartupControllerTests: XCTestCase {
    
    var delegateMock: ApphudStartupObservingDelegateMock!
    var startupStorageProviderMock: StartupStorageProviderMock!
    var stringKeyValueStorageMock: StringKeyValueStorageMock!
    var controller: ApphudStartupController!
    
    private let apiKey = "test_api_key"
    
    override func setUp() {
        super.setUp()
        delegateMock = ApphudStartupObservingDelegateMock()
        stringKeyValueStorageMock = StringKeyValueStorageMock()
        startupStorageProviderMock = StartupStorageProviderMock(storage: stringKeyValueStorageMock)
        controller = ApphudStartupController()
        controller.delegate = delegateMock
    }
    
    override func tearDown() {
        delegateMock = nil
        startupStorageProviderMock = nil
        stringKeyValueStorageMock = nil
        controller = nil
        super.tearDown()
    }
    
    func testStartupParameters() {
        let parameters = controller.startupParameters()
        XCTAssertNotNil(parameters["request"], "Startup parameters should contain a request key")
    }
    
    func testStartupUpdatedWithAPIKey() {
        //Arrange
        controller.setupStartupProvider(startupStorageProviderMock, cachingStorageProvider: startupStorageProviderMock)
        let delegateExpectation = XCTestExpectation(description: "Delegate should be notified")
        delegateExpectation.expectedFulfillmentCount = 1
        delegateMock.expectation = delegateExpectation
        let saveExpectation = XCTestExpectation(description: "Storage should be saved")
        startupStorageProviderMock.saveExpectation = saveExpectation
        
        //Act
        controller.startupUpdated(withParameters: ["apphud": ["apikey": apiKey],
                                                   "features": ["list": ["apphud": ["enabled": true]]]])
        
        //Assert
        wait(for: [delegateExpectation, saveExpectation], timeout: 1.0)
        XCTAssertEqual(try? stringKeyValueStorageMock.string(forKey: ApphudStartupConfiguration.apphudStorageKey), apiKey,
                       "Storage should save the correct API key")
        XCTAssertEqual(try? stringKeyValueStorageMock.boolNumber(forKey: ApphudStartupConfiguration.apphudEnabledKey), 1,
                       "Storage should save apphud feature")
        XCTAssertNotNil(self.controller.startupConfiguration, "Startup configuration should be set")
    }
    
    func testSetupStartupProvider() {
        //Arrange
        let delegateExpectation = XCTestExpectation(description: "Delegate should be notified on setup")
        delegateExpectation.expectedFulfillmentCount = 1
        delegateMock.expectation = delegateExpectation
        
        //Act
        controller.setupStartupProvider(startupStorageProviderMock, cachingStorageProvider: startupStorageProviderMock)
        
        //Assert
        wait(for: [delegateExpectation], timeout: 1.0)
    }
}
