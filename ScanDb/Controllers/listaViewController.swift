//
//  listaViewController.swift
//  ScanDb
//
//  Created by Aidan Silva on 16/06/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class listaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var scannedCode: String?
    
    @IBOutlet weak var codelabel: UILabel!
    @IBOutlet weak var tablaProductos: UITableView!
    
    var articulos:[Articulo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablaProductos.dataSource = self
        tablaProductos.delegate = self

        if let code = scannedCode {
            codelabel.text = code
        }
        
        //Llamado de DB para llenar array de artículos
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            let articulo = Articulo()
            articulo.barcode = (snapshot.value as! NSDictionary)["barcode"] as! String
            articulo.nombre = (snapshot.value as! NSDictionary)["descripcion"] as! String
            articulo.cantidad = (snapshot.value as! NSDictionary)["cantidad"] as! String
            articulo.precio = (snapshot.value as! NSDictionary)["precio"] as! String
            self.articulos.append(articulo)
            self.tablaProductos.reloadData()
        })
    }
    
    @IBAction func cerrarSess(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articulos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let articulo = articulos[indexPath.row]
        cell.textLabel?.text = articulo.nombre
        cell.detailTextLabel?.text = "Cantidad: \(articulo.cantidad) Precio: S/.\(articulo.precio)"
        return cell
    }
}
