//
//  AVIFImageDecoderTests.swift
//  Nuke-AVIF-Plugin
//
//  Created by nagisa-kosuge on 2018/05/08.
//  Copyright © 2018年 RyoKosuge. All rights reserved.
//

import XCTest
import Nuke
@testable import NukeAVIFPlugin

class AVIFImageDecoderTests: XCTestCase {
    
    private lazy var avifImagePath: URL = {
        let avifImagePath = BundleToken.bundle.url(forResource: "sample", withExtension: "avif")!
        return avifImagePath
    }()

    private lazy var avifImageURL: URL = URL(string: "https://resources.link-u.co.jp/avif/red-at-12-oclock-with-color-profile-10bpc.avif")!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testsProgressiveDecodeAVIFImageDecoder() throws {
        let avifData = try Data(contentsOf: self.avifImagePath)
        let decoder = NukeAVIFPlugin.AVIFImageDecoder()
        
        // no image
        XCTAssertThrowsError(try decoder.decode(avifData[0...500]))
        
        // created image
        XCTAssertThrowsError(try decoder.decode(avifData[0...3702]))

        let scan2 = try decoder.decode(avifData)
        XCTAssertNotNil(scan2)
        XCTAssertEqual(scan2.image.size.width, 200)
        XCTAssertEqual(scan2.image.size.height, 180)
    }

    func testsImageDecoderRegistryRegistered() {
        let exception = XCTestExpectation(description: "decode avif image")
        Nuke.DataLoader.sharedUrlCache.removeAllCachedResponses()
        AVIFImageDecoder.enable()
        let request = ImageRequest(url: self.avifImageURL)
        Nuke.ImagePipeline.shared.loadImage(with: request, progress: nil) { (result) in
            switch result {
            case .success(let imageResponse):
                XCTAssertNotNil(imageResponse.image)
            case .failure(let error):
                XCTFail("decoding failed: \(error)")
            }
            exception.fulfill()
        }

        self.wait(for: [exception], timeout: 2)
    }

}
