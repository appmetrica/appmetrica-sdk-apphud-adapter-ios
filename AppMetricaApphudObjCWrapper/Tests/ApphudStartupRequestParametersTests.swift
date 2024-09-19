
import XCTest
@testable import AppMetricaApphudObjCWrapper

final class ApphudStartupRequestParametersTests: XCTestCase {
    
    var requestParameters: ApphudStartupRequestParameters!
    
    override func setUp() {
        super.setUp()
        requestParameters = ApphudStartupRequestParameters()
    }
    
    override func tearDown() {
        requestParameters = nil
        super.tearDown()
    }
    
    func testParameters() {
        let expectedParameters: [String: Any] = [
            "features": "ah",
            "ah": "1"
        ]
        
        XCTAssertEqual(requestParameters.parameters as NSDictionary, expectedParameters as NSDictionary,
                       "Parameters should match the expected dictionary")
    }
}
