// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Nuke-AVIF-Plugin",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        ],
    products: [
        .library(name: "NukeAVIFPlugin", targets: ["NukeAVIFPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Nuke.git", .upToNextMajor(from: "10.0.0")),
        .package(url: "https://github.com/delneg/libavif.git", from: "0.9.3")
    ],
    targets: [
        .target(
            name: "NukeAVIFPlugin",
            dependencies: ["Nuke", "libavif"],
            path: "Source",
            exclude: [
                "AVIF",
            ],
            sources: [
                "AVIFImage.swift",
                "Extensions",
            ]
        )
    ]
)
