// swift-tools-version:5.8

import PackageDescription
import Foundation

// MARK: - Dependencies

func hasFile(_ path: String) -> Bool {
    FileManager.default.fileExists(
        atPath: URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent(path)
            .path
    )
}

// DO NOT CHANGE DEFAULT VALUES IN TRANK
let useAppMetricaLocal = hasFile(".spm-use-appmetrica-local") || false
let useSpmExternal = hasFile(".spm-use-spm-external") || false

struct ExternalDependency {
    let package: String
    let dependency: Package.Dependency

    init(url: String, spmExternalId: String, version: VersionSpec, localPath: String? = nil) {
        if localPath != nil {
            self.package = spmExternalId
            self.dependency = .package(name: self.package, path: localPath!)
        } else if useSpmExternal {
            self.package = "spm-external.\(spmExternalId)"
            self.dependency = switch version {
            case .upToNextMajor(from: let from): .package(id: package, .upToNextMajor(from: from))
            case .exact(let v): .package(id: package, exact: v)
            }
        } else {
            self.package = URL(string: url)!.lastPathComponent
            self.dependency = switch version {
            case .upToNextMajor(from: let from): .package(url: url, .upToNextMajor(from: from))
            case .exact(let v): .package(url: url, exact: v)
            }
        }
    }

    enum VersionSpec {
        case upToNextMajor(from: Version)
        case exact(Version)
    }
}

enum AppMetrica {
    private static let dep = ExternalDependency(
        url: "https://github.com/appmetrica/appmetrica-sdk-ios",
        spmExternalId: "AppMetrica",
        version: .upToNextMajor(from: "6.0.0"),
        localPath: useAppMetricaLocal ? "../../public" : nil,
    )

    static let dependency: Package.Dependency = dep.dependency
    static let core: Target.Dependency = .product(name: "AppMetricaCore", package: dep.package)
}

enum ApphudSDK {
    private static let dep = ExternalDependency(
        url: "https://github.com/apphud/ApphudSDK",
        spmExternalId: "ApphudSDK",
        version: .upToNextMajor(from: "3.0.0"),
    )

    static let dependency: Package.Dependency = dep.dependency
    static let apphudSdk: Target.Dependency = .product(name: "ApphudSDK", package: dep.package)
}

enum Kiwi {
    private static let dep = ExternalDependency(
        url: "https://github.com/appmetrica/Kiwi",
        spmExternalId: "Kiwi",
        version: .exact("3.0.1-spm"),
    )

    static let dependency: Package.Dependency = dep.dependency
    static let kiwi: Target.Dependency = .product(name: "Kiwi", package: dep.package)
}

// MARK: - Module

protocol ModuleDependency {
    var asTargetDependency: Target.Dependency { get }
}

extension String : ModuleDependency {
    var asTargetDependency: Target.Dependency { .target(name: self) }
}

extension Target.Dependency : ModuleDependency {
    var asTargetDependency: Target.Dependency { self }
}

struct Module {
    let name: String
    let dependencies: [Target.Dependency]
    let hasTests: Bool
    let testDependencies: [Target.Dependency]

    init(name: String, dependencies: [ModuleDependency], hasTests: Bool = true, testDependencies: [ModuleDependency] = []) {
        self.name = name
        self.dependencies = dependencies.map(\.asTargetDependency)
        self.hasTests = hasTests
        self.testDependencies = testDependencies.map(\.asTargetDependency)
    }

    func toTargets() -> [Target] {
        let headerSearchPaths = [
            ".",
            "include",
            "include/\(name)",
        ]
        var targets: [Target] = [
            .target(
                name: name,
                dependencies: dependencies,
                path: "\(name)/Sources",
                resources: [.copy("Resources/PrivacyInfo.xcprivacy")],
                cSettings: headerSearchPaths.map { .headerSearchPath($0) },
            )
        ]
        if hasTests {
            targets.append(
                .testTarget(
                    name: "\(name)Tests",
                    dependencies: [.target(name: name)] + dependencies + testDependencies,
                    path: "\(name)/Tests",
                    cSettings: [
                        .headerSearchPath("."),
                    ] + headerSearchPaths.map { .headerSearchPath("../Sources/\($0)") },
                )
            )
        }
        return targets
    }
}

extension Module {
    static let apphudAdapter = "AppMetricaApphudAdapter"
    static let objcWrapper = "AppMetricaApphudObjCWrapper"
    static let testUtils = "AppMetricaApphudTestUtils"
}

// MARK: - Apphud Adapter Module

let apphudAdapter = Module(
    name: Module.apphudAdapter,
    dependencies: [
        Module.objcWrapper,
        AppMetrica.core,
    ],
    testDependencies: [
        Kiwi.kiwi,
    ],
)

// MARK: - ObjC Wrapper Module

let objcWrapper = Module(
    name: Module.objcWrapper,
    dependencies: [
        AppMetrica.core,
        ApphudSDK.apphudSdk,
    ],
    testDependencies: [
        Module.testUtils,
    ],
)

// MARK: - Test Utils Module

let testUtils = Module(
    name: Module.testUtils,
    dependencies: [
        AppMetrica.core,
    ],
    hasTests: false,
)

// MARK: - Package definition

let package = Package(
    name: "AppMetricaApphudAdapter",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "AppMetricaApphudAdapter", targets: [Module.apphudAdapter]),
        .library(name: "AppMetricaApphudObjCWrapper", targets: [Module.objcWrapper]),
    ],
    dependencies: [
        AppMetrica.dependency,
        ApphudSDK.dependency,
        Kiwi.dependency,
    ],
    targets: [
        apphudAdapter,
        objcWrapper,
        testUtils,
    ].flatMap { $0.toTargets() }
)
