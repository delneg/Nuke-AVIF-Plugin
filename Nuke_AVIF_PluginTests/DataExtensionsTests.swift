//
//  DataExtensionsTests.swift
//  Nuke-AVIF-Plugin
//
//  Created by delneg on 2021/12/05.
//  Copyright © 2021 delneg. All rights reserved.
//

import XCTest
@testable import NukeAVIFPlugin

class DataExtensionsTests: XCTestCase {

    private lazy var avifImagePath: URL = {
        let avifImagePath = BundleToken.bundle.url(forResource: "sample", withExtension: "avif")!
        return avifImagePath
    }()
    
    private lazy var gifImagePath: URL = {
        let gifImagePath = BundleToken.bundle.url(forResource: "sample", withExtension: "gif")!
        return gifImagePath
    }()

    private lazy var webpImagePath: URL = {
        let webpImagePath = BundleToken.bundle.url(forResource: "sample", withExtension: "webp")!
        return webpImagePath
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testsDataIsAVIFFormat() throws {
        let avifData = try Data(contentsOf: self.avifImagePath)
        XCTAssertTrue(avifData.isAVIFFormat)

        let gifData = try Data(contentsOf: self.gifImagePath)
        XCTAssertFalse(gifData.isAVIFFormat)

        let webpData = try Data(contentsOf: self.webpImagePath)
        XCTAssertFalse(webpData.isAVIFFormat)
    }

    func testsNoData() {
        let data = Data(count: 0)
        XCTAssertFalse(data.isAVIFFormat)
    }

}
