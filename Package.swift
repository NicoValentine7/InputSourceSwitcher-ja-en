// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "InputSourceSwitcher",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "InputSourceSwitcher",
            dependencies: [],
            linkerSettings: [
                .linkedFramework("Cocoa"),
                .linkedFramework("Carbon")
            ]
        )
    ]
)
