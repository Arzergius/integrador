//
//  verDetalleViewController.swift
//  ScanDb
//
//  Created by Aidan Silva on 28/06/23.
//

import UIKit
import SDWebImage
import Firebase

class verDetalleViewController: UIViewController {

    var articulo = Articulo()
    @IBOutlet weak var barcode: UILabel!
    @IBOutlet weak var nombreartc: UILabel!
    @IBOutlet weak var cantidadartc: UILabel!
    @IBOutlet weak var precioartc: UILabel!
    @IBOutlet weak var imagenartc: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barcode.text = "Codigo de Barras : " + articulo.barcode
        nombreartc.text = "Nombre : " + articulo.nombre
        cantidadartc.text = "Cantidad : " + articulo.cantidad
        precioartc.text = "Precio : S/." + articulo.precio
        imagenartc.sd_setImage(with: URL(string: articulo.imagenURL), completed: nil)

        // Do any additional setup after loading the view.
    }
    
}
