
import XCTest
@testable import AppMetricaApphudObjCWrapper

final class ApphudStartupResponseParserTests: XCTestCase {
    
    var parser: ApphudStartupResponseParser!
    var mockStorage: StringKeyValueStorageMock!
    
    override func setUp() {
        super.setUp()
        parser = ApphudStartupResponseParser()
        mockStorage = StringKeyValueStorageMock()
    }
    
    override func tearDown() {
        parser = nil
        mockStorage = nil
        super.tearDown()
    }
    
    func testStartupConfigurationWithValidResponse() {
        let validResponse: [AnyHashable: Any] = [
            "apphud": ["apikey": "test_api_key"],
            "features": [
                "list": [
                    "apphud": [
                        "enabled": true
                    ]
                ]
            ]
        ]
        
        let configuration = parser.startupConfiguration(storage: mockStorage, response: validResponse)
        
        XCTAssertEqual(configuration.apphudAPIKey, "test_api_key", "API key should be correctly parsed from the response.")
        XCTAssertTrue(configuration.apphudEnabled!.boolValue, "Feature should be correctly parsed from the response.")
    }
    
    func testStartupConfigurationWithInvalidResponse() {
        let invalidResponse: [AnyHashable: Any] = [:]
        
        let configuration = parser.startupConfiguration(storage: mockStorage, response: invalidResponse)
        
        XCTAssertNil(configuration.apphudAPIKey, "API key should be nil when the response does not contain the expected data.")
        XCTAssertNil(configuration.apphudEnabled, "Feature should be nil when the response does not contain the expected data.")
    }
    
    func testStartupConfiguration_withEmptyAPIKey() {
        let emptyAPIKeyResponse: [AnyHashable: Any] = [
            "apphud": ["apikey": ""]
        ]
        
        let configuration = parser.startupConfiguration(storage: mockStorage, response: emptyAPIKeyResponse)
        
        XCTAssertEqual(configuration.apphudAPIKey, "", "API key should be an empty string when the response contains an empty API key.")
    }
}
