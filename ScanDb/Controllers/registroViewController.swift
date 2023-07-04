//
//  registroViewController.swift
//  ScanDb
//
//  Created by Aidan Silva on 16/06/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class registroViewController: UIViewController {
    
    
    @IBOutlet weak var correotxtlbl: UITextField!
    @IBOutlet weak var passwordtxtlbl: UITextField!
    @IBOutlet weak var myButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        myButton.layer.cornerRadius = myButton.frame.height / 2 // Redondear completamente el botón
            // Opcionalmente, puedes establecer el atributo clipsToBounds en true para asegurarte de que el contenido del botón no se desborde
            myButton.clipsToBounds = true
       // modalPresentationStyle = .fullScreen
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnregistro(_ sender: Any) {
        guard let usuario = correotxtlbl.text, !usuario.isEmpty,
              let password =  passwordtxtlbl.text, !password.isEmpty else{
            let alerta = UIAlertController(title: "Error", message: "Ingrese un correo y contraseña ", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "Aceptar", style: .default)
            alerta.addAction(btnOK)
            present(alerta, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: usuario, password: password) { (authResult, error) in
            if let error = error{
                let alerta = UIAlertController(title: "Error", message: "No se pudo crear el usuario:\(error.localizedDescription)", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default)
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
                return
            }
            
            if let user = authResult?.user{
                let ref = Database.database().reference()
                ref.child("usuarios").child(user.uid).child("email").setValue(user.email)
                
                let alerta = UIAlertController(title: "Creacion de Usuario", message: "El usuario se creo correctamente", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
