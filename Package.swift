// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Nuke-AVIF-Plugin",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "NukeAVIFPlugin", targets: ["NukeAVIFPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Nuke.git", from: "11.0.0"),
        .package(url: "https://github.com/SDWebImage/libavif-Xcode.git", exact: "0.10.1")
    ],
    targets: [
        .target(
            name: "NukeAVIFPlugin",
            dependencies: [
                "NukeAVIFPluginC",
                "Nuke",
                .product(name: "libavif", package: "libavif-Xcode"),
            ],
            path: "Source",
            exclude: [
                "AVIF",
            ],
            sources: [
                "AVIFImage.swift",
                "Extensions",
            ]
        ),
        .target(
            name: "NukeAVIFPluginC",
            path: "Source",
            exclude: [
                "AVIFImage.swift",
                "Extensions",
            ],
            publicHeadersPath: "AVIF",
            cSettings: [
                .headerSearchPath("AVIF/include/"),
            ]
        ),
    ]
)
