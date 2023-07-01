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
        
        //navigationItem = self.navigationItem
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
            articulo.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            self.articulos.append(articulo)
            self.tablaProductos.reloadData()
        })
    }
    
    @IBAction func cerrarSess(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articulo = articulos[indexPath.row]
        performSegue(withIdentifier: "delistaadetalle", sender: articulo)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "delistaadetalle" {
            let siguienteVC = segue.destination as! verDetalleViewController
            siguienteVC.articulo = sender as! Articulo
        }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let articulo = articulos[indexPath.row]
            
            // Eliminar el artículo de la lista
            articulos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Falta que elimine de la base de datos mas
            
        }}

//SOBRECARGA DE LA VISTA SOLO PARA BOTONES
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Opciones", primaryAction: nil, menu: menuItems())
    }
// AGREGAR BOTONES DE IZQUIERDA
    func menuItems() -> UIMenu {
        let editAction = UIAction(title: "Editar", image: UIImage(systemName: "wrench.adjustable")) { [weak self] (_) in
            self?.toggleEditMode()
        }
        let cerrarSesionAction = UIAction(title: "Cerrar Sesión", image: UIImage(systemName: "person.crop.circle.badge.xmark")) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
        
        let addMenuItems = UIMenu(title: "La Putah Famah Daaa 😝", options: .displayInline, children: [
            cerrarSesionAction,
            editAction
        ])
        
        return addMenuItems
    }

    func toggleEditMode() {
        // Toggle the editing mode of the table
        let isEditing = tablaProductos.isEditing
        tablaProductos.setEditing(!isEditing, animated: true)
    }


}
