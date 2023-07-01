//
//  filtradoDetalleViewController.swift
//  ScanDb
//
//  Created by Aidan Silva on 28/06/23.
//
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import SDWebImage

class filtradoDetalleViewController: UIViewController {

    var scannedCode: String?
    var articulos: [Articulo] = []
    
    @IBOutlet weak var cdgbarrafiltered: UILabel!
    @IBOutlet weak var nombrefilterd: UILabel!
    @IBOutlet weak var cantidadfiltered: UILabel!
    @IBOutlet weak var precioFiltered: UILabel!
    @IBOutlet weak var imagenfiltered: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            let articulo = Articulo()
            articulo.barcode = (snapshot.value as! NSDictionary)["barcode"] as! String
            articulo.nombre = (snapshot.value as! NSDictionary)["descripcion"] as! String
            articulo.cantidad = (snapshot.value as! NSDictionary)["cantidad"] as! String
            articulo.precio = (snapshot.value as! NSDictionary)["precio"] as! String
            articulo.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            self.articulos.append(articulo)
            
            if articulo.barcode == self.scannedCode {
                self.updateUI(with: articulo)
            } else {
                print("No se encontró ningún artículo con el código de barras escaneado")
                print(self.scannedCode)
            }
        })
        
        if let code = scannedCode {
            cdgbarrafiltered.text = "Codigo de Barras: " + code
        } else {
            print("El código de barras escaneado es nulo")
        }
    }
    
    func updateUI(with articulo: Articulo) {
        nombrefilterd.text = "Nombre: " + articulo.nombre
        cantidadfiltered.text = "Cantidad: " + articulo.cantidad
        precioFiltered.text = "Precio: " + articulo.precio
        
        let imagenURL = articulo.imagenURL
        imagenfiltered.sd_setImage(with: URL(string: imagenURL), completed: { (_, error, _, _) in
            if let error = error {
                print("Error al cargar la imagen:", error.localizedDescription)
            }
        })
    }
}
