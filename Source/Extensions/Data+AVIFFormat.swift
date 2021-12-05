//
//  Data+AVIFFormat.swift
//  Nuke-AVIF-Plugin iOS
//
//  Created by delneg on 2021/12/05.
//  Copyright © 2021 delneg. All rights reserved.
//

//https://www.garykessler.net/library/file_sigs.html
import Foundation

private let fileHeaderIndex: Int = 4

private let avifBytes: [UInt8] =         [
    0x66, 0x74, 0x79, 0x70, // ftyp
    0x61, 0x76, 0x69, 0x66  // avif
]
private let magicBytesEndIndex: Int = fileHeaderIndex+avifBytes.count
// MARK: - AVIF Format Testing
extension Data {

    internal var isAVIFFormat: Bool {
        guard magicBytesEndIndex < count else { return false }
        let bytesStart = index(startIndex, offsetBy: fileHeaderIndex)
        let data = subdata(in: bytesStart..<magicBytesEndIndex)
        return data.elementsEqual(avifBytes)
    }

}
