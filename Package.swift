// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Nuke-AVIF-Plugin",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_13),
        ],
    products: [
        .library(name: "NukeAVIFPlugin", targets: ["NukeAVIFPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Nuke.git", .upToNextMajor(from: "9.2.3")),
        .package(url: "https://github.com/SDWebImage/libavif-Xcode", from: "0.9.1")
    ],
    targets: [
        .target(
            name: "NukeAVIFPlugin",
            dependencies: ["Nuke", "libavif-Xcode"],
            path: "Source",
            exclude: [
//                "libavif",
                "AVIF",
            ],
            sources: [
                "AVIFImage.swift",
                "Extensions",
            ]
        )
//        .target(
//            name: "NukeAVIFPluginC",
//            path: "Source",
//            exclude: [
//                "WebPImage.swift",
//                "Extensions",
//            ],
//            publicHeadersPath: "AVIF",
//            cSettings: [
//                .headerSearchPath("libavif"),
//                .headerSearchPath("libavif/include/"),
//            ],
//            cxxSettings: [
//              .headerSearchPath("libavif"),
//              .headerSearchPath("libavif/include/"),
//            ]
//        ),
    ]
)
