//
//  logeoViewController.swift
//  ScanDb
//
//  Created by Aidan Silva on 16/06/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class logeoViewController: UIViewController {

    @IBOutlet weak var correotxtfield: UITextField!
    @IBOutlet weak var passwordtxtfield: UITextField!
    
    
    @IBAction func logeobutton(_ sender: Any) {
        Auth.auth().signIn(withEmail: correotxtfield.text! , password: passwordtxtfield.text!) {(user, error) in
            print("Intentando Iniciar Sesion")
            if error != nil {
                print("Error de \(error!.localizedDescription)")
                
                let alerta = UIAlertController(title: "Error", message: "El usuario no existe o los datos son incorrectos", preferredStyle: .alert)
                
                let btnOk = UIAlertAction(title: "Aceptar", style: .default)
                alerta.addAction(btnOk)
                self.present(alerta,animated: true, completion: nil)
            }else{
                print("Logeo correcto")
                self.performSegue(withIdentifier: "logeocorrecto", sender: nil)
            }
        }
        //        Modo desarrollador sin login
//                self.performSegue(withIdentifier: "logeocorrecto", sender: nil)
        //    }
        //
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //Función para cerrar teclado al hacer tap en pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        correotxtfield.resignFirstResponder()
        passwordtxtfield.resignFirstResponder()
    }
}
