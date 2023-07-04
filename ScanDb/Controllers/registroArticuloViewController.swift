//
//  registroArticuloViewController.swift
//  ScanDb
//
//  Created by Aidan Silva on 20/06/23.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class registroArticuloViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var scannedCode: String?
    
    @IBOutlet weak var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate =  self
        myButton.layer.cornerRadius = myButton.frame.height / 2 // Redondear completamente el botón
            // Opcionalmente, puedes establecer el atributo clipsToBounds en true para asegurarte de que el contenido del botón no se desborde
            myButton.clipsToBounds = true
        
        if let code = scannedCode {
            txtfieldbarcode.text = code
        }
        
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // Ocultar el teclado
    }
    @IBAction func btnCamera(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var imagenProduct: UIImageView!
    @IBOutlet weak var txtfieldbarcode: UITextField!
    @IBOutlet weak var txtfieldnombre: UITextField!
    @IBOutlet weak var txtfieldCantidad: UITextField!
    @IBOutlet weak var txtfieldPrecio: UITextField!
     
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagenProduct.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    func mostrarAlerta(titulo:String,mensaje:String, accion:String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: titulo, style: .default,handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta,animated: true,completion: nil)
    }
    func limpiarCampos() {
        txtfieldbarcode.text = ""
        txtfieldnombre.text = ""
        txtfieldCantidad.text = ""
        txtfieldPrecio.text = ""
        imagenProduct.image = nil
    }
    
    @IBAction func registrobtn(_ sender: Any) {
        guard let user = Auth.auth().currentUser else {
                mostrarAlerta(titulo: "Error", mensaje: "No se ha iniciado sesión", accion: "Aceptar")
                return
            }
            
            // Obtener los datos del formulario
            guard let barcode = txtfieldbarcode.text, !barcode.isEmpty,
                  let nombre = txtfieldnombre.text, !nombre.isEmpty,
                  let cantidad = txtfieldCantidad.text, !cantidad.isEmpty,
                  let precio = txtfieldPrecio.text, !precio.isEmpty,
                  let imagen = imagenProduct.image else {
                mostrarAlerta(titulo: "Error", mensaje: "Complete todos los campos", accion: "Aceptar")
                return
            }
            
            // Convertir la imagen a data en formato JPEG
            guard let imagenData = imagen.jpegData(compressionQuality: 0.50) else {
                mostrarAlerta(titulo: "Error", mensaje: "No se pudo obtener la imagen", accion: "Aceptar")
                return
            }
            
            // Crear una referencia a la carpeta "imagenes" en Firebase Storage
            let imagenesFolder = Storage.storage().reference().child("imagenes")
            
            // Generar un ID único para la imagen
            let imagenID = NSUUID().uuidString
            
            // Crear una referencia a la imagen utilizando el ID único
            let imagenRef = imagenesFolder.child("\(imagenID).jpg")
            
            // Subir la imagen a Firebase Storage
            let uploadTask = imagenRef.putData(imagenData, metadata: nil) { (metadata, error) in
                if let error = error {
                    self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo subir la imagen: \(error.localizedDescription)", accion: "Aceptar")
                    return
                }
                
                // Obtener la URL de descarga de la imagen
                imagenRef.downloadURL { (url, error) in
                    if let error = error {
                        self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo obtener la URL de la imagen: \(error.localizedDescription)", accion: "Aceptar")
                        return
                    }
                    
                    guard let downloadURL = url?.absoluteString else {
                        self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo obtener la URL de la imagen", accion: "Aceptar")
                        return
                    }
//                    guard let articuloID = self.txtfieldbarcode.text else {
//                                    mostrarAlerta(titulo: "Error", mensaje: "No se pudo obtener el ID del artículo", accion: "Aceptar")
//                                    return
//                                }
//                    let articuloRef = Database.database().reference().child("Articulos").child(articuloID)
//                                articuloRef.updateChildValues(["imagenURL": downloadURL.absoluteString])
//
                    
                    // Crear el diccionario con la información del snap
                    let snap = [
                        "from": user.email ?? "",
                        "descripcion": nombre,
                        "imagenURL": downloadURL,
                        "imagenID": imagenID,
                        "barcode": barcode,
                        "precio": precio,
                        "cantidad": cantidad
                    ]
                    
                    // Guardar el snap en la base de datos del usuario actual
                    Database.database().reference().child("usuarios").child(user.uid).child("snaps").childByAutoId().setValue(snap) { (error, _) in
                        if let error = error {
                            self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo guardar el snap: \(error.localizedDescription)", accion: "Aceptar")
                            return
                        }
                        
                        // Limpiar los campos y mostrar una alerta de éxito
                        self.limpiarCampos()
                        self.mostrarAlerta(titulo: "Éxito", mensaje: "El snap se ha guardado exitosamente", accion: "Aceptar")
                        
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
}
