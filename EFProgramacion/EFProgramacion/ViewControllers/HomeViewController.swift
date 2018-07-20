//
//  HomeViewController.swift
//  EFProgramacion
//
//  Created by E4409 on 7/13/18.
//  Copyright © 2018 E4409. All rights reserved.
//

import Firebase
import FirebaseAuth
import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txt_usr: UITextField!
    @IBOutlet weak var txt_pss: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_usr.delegate = self
        self.txt_pss.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func act_access(_ sender: Any) {
        // Verificar que los campos no estén vacíos
        if txt_usr.text != "" {
            if txt_pss.text != "" {
                // Logica de acceso
                Auth.auth().signIn(withEmail: "\(txt_usr.text!)@aloe.ulima.edu.pe", password: txt_pss.text!) { (user, error) in
                    if error != nil {
                        self.show_msg(ttl: "Error", msg: "Credenciales incorrectas.")

                        return
                    }

                    UserDefaults.standard.set(self.txt_usr.text ,forKey: "USERNAME")

                    self.performSegue(withIdentifier: "to_main", sender: self)
                }
            } else {
                show_msg(ttl: "Error", msg: "Ingrese su contraseña.")
            }
        } else {
            show_msg(ttl: "Error", msg: "Ingrese su usuario.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func show_msg(ttl: String, msg: String){
        let alert = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }

}
