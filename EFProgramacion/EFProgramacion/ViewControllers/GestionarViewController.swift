//
//  GestionarViewController.swift
//  EFProgramacion
//
//  Created by David Campos on 7/18/18.
//  Copyright © 2018 E4409. All rights reserved.
//

import UIKit

class GestionarViewController: UIViewController {

    @IBOutlet weak var image_view: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image_view.downloadedFrom(link: "https://i2.wp.com/thebutlercollegian.com/wp-content/uploads/2018/03/Books-.jpeg?w=1920&ssl=1")
    }

}
