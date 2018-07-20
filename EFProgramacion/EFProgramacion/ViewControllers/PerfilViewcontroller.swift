//
//  PerfilViewcontroller.swift
//  EFProgramacion
//
//  Created by David Campos on 7/18/18.
//  Copyright © 2018 E4409. All rights reserved.
//

import UIKit

class PerfilViewcontroller: UIViewController {
    let access : Firebase_Access = Firebase_Access()
    
    @IBOutlet weak var pFoto: UIImageView!
    @IBOutlet weak var pCodigo: UILabel!
    @IBOutlet weak var pNombre: UILabel!
    @IBOutlet weak var pCarrera: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userName = UserDefaults.standard.object(forKey: "USERNAME") as? String
        
        access.GetProfile(userName: userName!) { (profile) in
            self.pFoto.downloadedFrom(link: profile.foto)
            self.pCodigo.text = profile.code
            self.pNombre.text = profile.name
            self.pCarrera.text = profile.carrera
        }
    }
    
}
