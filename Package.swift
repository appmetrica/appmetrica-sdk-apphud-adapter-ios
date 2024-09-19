// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum AppMetricaApphudTarget: String {
    case apphudAdapter = "AppMetricaApphudAdapter"
    case objcWrapper = "AppMetricaApphudObjCWrapper"
    
    var name: String { rawValue }
    var testsName: String { rawValue + "Tests" }
    var path: String { "\(rawValue)/Sources" }
    var testsPath: String { "\(rawValue)/Tests" }
    var dependency: Target.Dependency { .target(name: rawValue) }
}

enum AppMetricaApphudProduct: String, CaseIterable {
    case apphudAdapter = "AppMetricaApphudAdapter"
    case objcWrapper = "AppMetricaApphudObjCWrapper"
    
    static var allProducts: [Product] { allCases.map { $0.product } }
    
    var targets: [AppMetricaApphudTarget] {
        switch self {
        case .apphudAdapter: return [.apphudAdapter]
        case .objcWrapper: return [.objcWrapper]
        }
    }
    
    var product: Product { .library(name: rawValue, targets: targets.map { $0.name }) }
}

enum ExternalDependency: String, CaseIterable {
    case appMetricaCore = "AppMetricaCore"
    case apphudSDK = "ApphudSDK"
    case kiwi = "Kiwi"
    
    static var allDependecies: [Package.Dependency] {
        return [.package(url: "https://github.com/apphud/ApphudSDK", .upToNextMajor(from: "3.0.0")),
                .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMajor(from: "5.8.0")),
                .package(url: "https://github.com/appmetrica/Kiwi", exact: "3.0.1-spm")]
    }
    
    var dependency: Target.Dependency {
        switch self {
        case .appMetricaCore:
            return .product(name: rawValue, package: "appmetrica-sdk-ios")
        case .apphudSDK, .kiwi:
            return .product(name: rawValue, package: rawValue)
        }
    }
}

let package = Package(
    name: "AppMetricaApphudAdapter",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: AppMetricaApphudProduct.allProducts,
    dependencies: ExternalDependency.allDependecies,
    targets: [
        //MARK: - AppMetrica Apphud Adapter -
        .target(
            target: .apphudAdapter,
            dependencies: [.objcWrapper],
            externalDependencies: [.appMetricaCore]
        ),
        //MARK: - AppMetrica Apphud ObjC Wrapper -
        .target(
            target: .objcWrapper,
            dependencies: [],
            externalDependencies: [.appMetricaCore, .apphudSDK]
        ),
        //MARK: - Unit tests -
        .testTarget(
            target: .apphudAdapter,
            dependencies: [.apphudAdapter],
            externalDependencies: [.kiwi]
        ),
        .testTarget(
            target: .objcWrapper,
            dependencies: [.objcWrapper],
            externalDependencies: []
        ),
    ]
)

//MARK: - Helpers

extension Target {
    static func target(target: AppMetricaApphudTarget,
                       dependencies: [AppMetricaApphudTarget] = [],
                       externalDependencies: [ExternalDependency] = [],
                       searchPaths: [String] = [],
                       includePrivacyManifest: Bool = true) -> Target {
        var resources: [Resource] = []
        if includePrivacyManifest {
            resources.append(.copy("Resources/PrivacyInfo.xcprivacy"))
        }
        
        let resultSearchPath: Set<String> = target.headerPaths.union(searchPaths)

        return .target(
            name: target.name,
            dependencies: dependencies.map { $0.dependency } + externalDependencies.map { $0.dependency },
            path: target.path,
            resources: resources,
            cSettings: resultSearchPath.sorted().map { .headerSearchPath($0) }
        )
    }
    
    static func testTarget(target: AppMetricaApphudTarget,
                           dependencies: [AppMetricaApphudTarget] = [],
                           testUtils: [AppMetricaApphudTarget] = [],
                           externalDependencies: [ExternalDependency] = [],
                           searchPaths: [String] = [],
                           resources: [Resource]? = nil) -> Target {
        
        let resultSearchPath: Set<String> = target.testsHeaderPaths.union(searchPaths)
        
        return .testTarget(
            name: target.testsName,
            dependencies: dependencies.map { $0.dependency } + externalDependencies.map { $0.dependency },
            path: target.testsPath,
            resources: resources,
            cSettings: resultSearchPath.sorted().map { .headerSearchPath($0) }
        )
    }
    
}

//MARK: - Header paths

extension AppMetricaApphudTarget {
    
    var headerPaths: Set<String> {
        let commonPaths: Set<String> = [
            ".",
            "include",
            "include/\(name)"
        ]
        
        return commonPaths
    }
    
    var testsHeaderPaths: Set<String> {
        let commonPaths: Set<String> = [
            "."
        ]
        
        let moduleHeaderPaths = headerPaths.map { "../Sources/\($0)" }
        return commonPaths.union(moduleHeaderPaths)
    }
    
}
