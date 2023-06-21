//
//  listaViewController.swift
//  ScanDb
//
//  Created by Aidan Silva on 16/06/23.
//

import UIKit

class listaViewController: UIViewController {
    var scannedCode: String?
    
    
    @IBOutlet weak var codelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let code = scannedCode {
            codelabel.text = code
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cerrarSess(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
