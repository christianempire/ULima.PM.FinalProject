//
//  ConsultasLibrosViewController.swift
//  EFProgramacion
//
//  Created by David Campos on 7/18/18.
//  Copyright © 2018 E4409. All rights reserved.
//

import UIKit

class ConsultasLibrosViewController: UIViewController {

    let access : Firebase_Access = Firebase_Access()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        access.GetBooks({ (books) in
            // TODO
        })
    }

}
