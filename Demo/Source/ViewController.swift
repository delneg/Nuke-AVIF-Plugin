//
//  ViewController.swift
//  Demo
//
//  Created by delneg on 2021/12/05.
//  Copyright © 2021 delneg. All rights reserved.
//

import UIKit
import Nuke
import NukeAVIFPlugin

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let url = URL(string: "https://resources.link-u.co.jp/avif/red-at-12-oclock-with-color-profile-10bpc.avif"), let imageView = self.imageView {
            Nuke.loadImage(with: url, into: imageView, progress: {[imageView] (response, total, bytes) in
                imageView.image = response?.image
            }) { (result) in
                imageView.image = try? result.get().image
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

