# Nuke-AVIF-Plugin


A plugin for Nuke to display AVIF images.


Based on https://github.com/ryokosuge/Nuke-WebP-Plugin


## Usage

The plugin features a pre-configured Nuke.Manager with AVIF support, and an AVIFImage:

```swift
import Nuke
import NukeAVIFPlugin

AVIFImageDecoder.enable()

let imageView = UIImageView()
let avifimageURL = URL(string: "https://example.com/sample.avif")!
Nuke.loadImage(with: url, into: imageView)
```

## Installation

### [CocoaPods](https://cocoapods.org/)

```ruby
pod 'Nuke-AVIF-Plugin'
```

### [Carthage](https://github.com/Carthage/Carthage)

```ruby
github 'delneg/Nuke-AVIF-Plugin'
```

## Minimum Requirements

| Swift | Xcode | iOS | macOS | tvOS | watchOS |
|:-----:|:-----:|:---:|:-----:|:----:|:-------:|
| 5.1, 5.2 | 11.0 | 11.0 | 10.13 | 11.0 | 4.0 |

## Dependencies

| [Nuke](https://github.com/kean/Nuke) | [libavif](https://github.com/delneg/libavif-XCode) |
|:------------------------------------:|:--------------------------------------------------:|
|                >= 9.0                |                       v0.9.2                       |


## License

Nuke-AVIF-Plugin is available under the MIT license. See the LICENSE file for more info.
