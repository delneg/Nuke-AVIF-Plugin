//
//  AVIFDecodeTests_MacOS.swift
//  Nuke-AVIF-PluginTests macOS
//
//  Created by delneg on 2021/12/05.
//  Copyright © 2021 delneg. All rights reserved.
//

import XCTest
@testable import NukeAVIFPlugin
#if SWIFT_PACKAGE
import NukeAVIFPluginC
#endif

#if os(macOS)
class AVIFDecodeTests: XCTestCase {
    
    private lazy var avifImagePath: URL = {
        let avifImagePath = BundleToken.bundle.url(forResource: "sample", withExtension: "avif")!
        return avifImagePath
    }()
    
    private lazy var gifImagePath: URL = {
        let gifImagePath = BundleToken.bundle.url(forResource: "sample", withExtension: "gif")!
        return gifImagePath
    }()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testsDecodeAVIFImage() throws {
        let avifData = try Data(contentsOf: self.avifImagePath)
        if #unavailable(macOS 13.0) {
            let image: NSImage? = NSImage(data: avifData)
            XCTAssertNil(image)
        }

        let decoder = NukeAVIFPluginC.AVIFDataDecoder();
        let avifImage: NSImage? = decoder.decode(avifData)
        XCTAssertNotNil(avifImage)
    }
    
    func testsDecodeNotAVIFImage() throws {
        let gifData = try Data(contentsOf: self.gifImagePath)
        let image: NSImage? = NSImage(data: gifData)
        XCTAssertNotNil(image)

        let decoder = NukeAVIFPluginC.AVIFDataDecoder();
        let avifImage: NSImage? = decoder.decode(gifData)
        XCTAssertNil(avifImage)
    }
    
    func testsProgressiveDecodeAVIFImage() throws {
        let avifData = try Data(contentsOf: self.avifImagePath)
        let decoder = NukeAVIFPluginC.AVIFDataDecoder();
        // no image
        XCTAssertNil(decoder.incrementallyDecode(avifData[0...200]))

        // created image
        let scan1 = decoder.incrementallyDecode(avifData[0...8000])
        XCTAssertNotNil(scan1)
        XCTAssertEqual(scan1?.size.width, 200)
        XCTAssertEqual(scan1?.size.height, 180)

        let scan2 = decoder.incrementallyDecode(avifData)
        XCTAssertNotNil(scan2)
        XCTAssertEqual(scan2?.size.width, 200)
        XCTAssertEqual(scan2?.size.height, 180)
    }

    func testPerformanceDecodeAVIF() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            try? testsDecodeAVIFImage()
        }
    }
    
}
#endif
