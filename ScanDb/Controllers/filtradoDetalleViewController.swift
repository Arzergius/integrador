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
    
    @IBOutlet weak var cdgbarrafiltered: UILabel!
    @IBOutlet weak var nombrefilterd: UILabel!
    @IBOutlet weak var cantidadfiltered: UILabel!
    @IBOutlet weak var precioFiltered: UILabel!
    @IBOutlet weak var imagenfiltered: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let code = scannedCode {
            cdgbarrafiltered.text = "Codigo de Barras: " + code
            //nombrefilterd.text = "Nombre" + articulo.nombre
        }
        
    }
    
}
