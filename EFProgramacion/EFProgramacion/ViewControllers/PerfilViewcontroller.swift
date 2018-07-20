//
//  PerfilViewcontroller.swift
//  EFProgramacion
//
//  Created by David Campos on 7/18/18.
//  Copyright © 2018 E4409. All rights reserved.
//

import UIKit

class PerfilViewcontroller: UIViewController {
    let Access : Firebase_Access = Firebase_Access()
    
    @IBOutlet weak var pFoto: UIImageView!
    @IBOutlet weak var pCodigo: UILabel!
    @IBOutlet weak var pNombre: UILabel!
    @IBOutlet weak var pCarrera: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userId = UserDefaults.standard.object(forKey: "UserId") as! Int
        
        Access.GetUserById(userId: userId) { (user) in
            self.pFoto.downloadedFrom(link: user.Photo)
            self.pCodigo.text = String(user.UserId)
            self.pNombre.text = user.Name
            self.pCarrera.text = user.Career.Name
        }
    }
    
}
