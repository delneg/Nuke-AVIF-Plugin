//
//  AVIFImage.swift
//  Nuke-AVIF-Plugin
//
//  Created by delneg on 2021/12/05.
//  Copyright © 2021 delneg. All rights reserved.
//

import Foundation
import Nuke
#if SWIFT_PACKAGE
import NukeAVIFPluginC
#endif

public class AVIFImageDecoder: Nuke.ImageDecoding {

    private lazy var decoder: AVIFDataDecoder = AVIFDataDecoder()

    public init() {
    }

    public func decode(_ data: Data) -> ImageContainer? {
        guard data.isAVIFFormat else { return nil }
        guard let image = _decode(data) else { return nil }
        return ImageContainer(image: image)
    }

    public func decodePartiallyDownloadedData(_ data: Data) -> ImageContainer? {
        guard data.isAVIFFormat else { return nil }
        guard let image = decoder.incrementallyDecode(data) else { return nil }
        return ImageContainer(image: image)
    }

}

// MARK: - check avif format data.
extension AVIFImageDecoder {

    public static func enable() {
        Nuke.ImageDecoderRegistry.shared.register { (context) -> ImageDecoding? in
            AVIFImageDecoder.enable(context: context)
        }
    }

    public static func enable(context: Nuke.ImageDecodingContext) -> Nuke.ImageDecoding? {
        return context.data.isAVIFFormat ? AVIFImageDecoder() : nil
    }

}

// MARK: - private
private let _queue = DispatchQueue(label: "com.github.delneg.Nuke-AVIF-Plugin.DataDecoder")

extension AVIFImageDecoder {

    private func _decode(_ data: Data) -> PlatformImage? {
        return _queue.sync {
            return decoder.decode(data)
        }
    }

}
