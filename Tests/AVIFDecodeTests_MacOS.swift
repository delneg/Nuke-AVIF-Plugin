//
//  AVIFDecodeTests_MacOS.swift
//  Nuke-AVIF-PluginTests macOS
//
//  Created by delneg on 2021/12/05.
//  Copyright © 2021 delneg. All rights reserved.
//

import XCTest
import Nuke
@testable import NukeAVIFPlugin

class AVIFDecodeTests: XCTestCase {
    
    private lazy var avifImagePath: URL = {
        let avifImagePath = Bundle(for: type(of: self)).url(forResource: "sample", withExtension: "avif")!
        return avifImagePath
    }()
    
    private lazy var gifImagePath: URL = {
        let gifImagePath = Bundle(for: type(of: self)).url(forResource: "sample", withExtension: "gif")!
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
    
    func testsDecodeAVIFImage() {
        let avifData = try! Data(contentsOf: self.avifImagePath)
        let image: NSImage? = NSImage(data: avifData)
        XCTAssertNil(image)

        let decoder = NukeAVIFPlugin.AVIFDataDecoder();
        let avifImage: NSImage? = decoder.decode(avifData)
        XCTAssertNotNil(avifImage)
    }
    
    func testsDecodeNotAVIFImage() {
        let gifData = try! Data(contentsOf: self.gifImagePath)
        let image: NSImage? = NSImage(data: gifData)
        XCTAssertNotNil(image)

        let decoder = NukeAVIFPlugin.AVIFDataDecoder();
        let avifImage: NSImage? = decoder.decode(gifData)
        XCTAssertNil(avifImage)
    }
    
    func testsProgressiveDecodeAVIFImage() {
        let avifData = try! Data(contentsOf: self.avifImagePath)
        let decoder = NukeAVIFPlugin.AVIFDataDecoder();
        // no image
        XCTAssertNil(decoder.incrementallyDecode(avifData[0...500]))

        // created image
        let scan1 = decoder.incrementallyDecode(avifData[0...3702])
        XCTAssertNotNil(scan1)
        XCTAssertEqual(scan1!.size.width, 320)
        XCTAssertEqual(scan1!.size.height, 235)

        let scan2 = decoder.incrementallyDecode(avifData)
        XCTAssertNotNil(scan2)
        XCTAssertEqual(scan2!.size.width, 320)
        XCTAssertEqual(scan2!.size.height, 235)
    }

    func testPerformanceDecodeAVIF() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let avifData = try! Data(contentsOf: self.avifImagePath)
            let image: NSImage? = NSImage(data: avifData)
            XCTAssertNil(image)

            let decoder = NukeAVIFPlugin.AVIFDataDecoder();
            let avifImage: NSImage? = decoder.decode(avifData)
            XCTAssertNotNil(avifImage)
        }
    }
    
}
