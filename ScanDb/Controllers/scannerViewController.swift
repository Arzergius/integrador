import UIKit
import AVFoundation
import Firebase
import AVFoundation


class scannerViewController: UIViewController {

    @IBOutlet weak var barnumbertextfield: UITextField!

    var audioPlayer: AVAudioPlayer?
    @IBAction func registrobtn(_ sender: Any) {
        captureSession.stopRunning() // Detener la captura de video
        performSegue(withIdentifier: "iralregistroSegue", sender: nil)
    }
    
    // Session para la captura de video
    let captureSession = AVCaptureSession()

    // Capa de vista previa para mostrar la captura de video
    var previewLayer: AVCaptureVideoPreviewLayer!

    // Vista para mostrar la capa de vista previa
    @IBOutlet weak var previewView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            startCaptureSession() // Comenzar la captura de video
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            stopCaptureSession() // Detener la captura de video
        }
        
        // Función para comenzar la captura de video
    func startCaptureSession() {
            guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
            guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
            
            // Eliminar todas las entradas existentes de la sesión de captura
            for existingInput in captureSession.inputs {
                captureSession.removeInput(existingInput)
            }
            
            // Agregar la entrada de video a la sesión de captura
            captureSession.addInput(input)
            
            // Verificar si la salida de metadatos ya está agregada
            var metadataOutput: AVCaptureMetadataOutput!
            if let existingOutput = captureSession.outputs.first as? AVCaptureMetadataOutput {
                metadataOutput = existingOutput
            } else {
                metadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(metadataOutput)
            }
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13]
            
            // Comenzar la captura de video
            captureSession.startRunning()
        }
        
        // Función para detener la captura de video
        func stopCaptureSession() {
            captureSession.stopRunning()
        }
    override func viewDidLoad() {
        
        if let soundURL = Bundle.main.url(forResource: "Beep", withExtension: "mp3") {
                do {
                    // Inicializar el reproductor de audio
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    audioPlayer?.prepareToPlay()
                } catch {
                    print("Error al cargar el archivo de sonido: \(error.localizedDescription)")
                }
            }
        
        
        
        super.viewDidLoad()
        // Calcular el tamaño y la posición de la capa de vista previa
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        let previewWidth = screenWidth
        let previewHeight = screenHeight / 3
        let previewX: CGFloat = 0
        let previewY: CGFloat = navigationController?.navigationBar.frame.maxY ?? 0
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = CGRect(x: previewX, y: previewY, width: previewWidth, height: previewHeight)
                
        // Agregar la capa de vista previa a la vista
        previewView.layer.addSublayer(previewLayer)
        
        // Comenzar la captura de video
    }
    // A VER SI EXISTE
    func codigoExisteEnBaseDeDatos(barcode: String, completionHandler: @escaping (Bool) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completionHandler(false)
            return
        }
        
        let snapsRef = Database.database().reference().child("usuarios").child(currentUserID).child("snaps")
        
        snapsRef.observeSingleEvent(of: .value) { snapshot in
            for snap in snapshot.children {
                if let snapData = snap as? DataSnapshot,
                   let snapDict = snapData.value as? [String: Any],
                   let snapBarcode = snapDict["barcode"] as? String,
                   snapBarcode == barcode {
                    completionHandler(true)
                    return
                }
            }
            
            completionHandler(false)
        }
    }

//    func codigoExisteEnBaseDeDatos(barcode: String, completionHandler: @escaping (Bool) -> Void) {
//        let usersRef = Database.database().reference().child("usuarios")
//
//        usersRef.observeSingleEvent(of: .value) { snapshot in
//            for case let userSnapshot as DataSnapshot in snapshot.children {
//                guard let snapsDict = userSnapshot.childSnapshot(forPath: "snaps").value as? [String: Any] else {
//                    continue
//                }
//
//                for snapDict in snapsDict.values {
//                    guard let snap = snapDict as? [String: Any],
//                          let snapBarcode = snap["barcode"] as? String else {
//                        continue
//                    }
//
//                    if snapBarcode == barcode {
//                        completionHandler(true)
//                        return
//                    }
//                }
//            }
//
//            completionHandler(false)
//        }
//    }

//FIN DEL A VER SI EXISTE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "iralregistroSegue"{
            if let destinoVC = segue.destination as? registroArticuloViewController {
                destinoVC.scannedCode = barnumbertextfield.text
            }
        } else if segue.identifier == "filtradosegue"{
            if let destinoVC = segue.destination as? filtradoDetalleViewController{
                destinoVC.scannedCode = barnumbertextfield.text
                //destinoVC.articulos = self.articulos
            }
        }
    }
}

extension scannerViewController: AVCaptureMetadataOutputObjectsDelegate {
   
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadataObject in metadataObjects {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let codeValue = readableObject.stringValue else { continue }

            barnumbertextfield.text = codeValue // Mostrar el valor del código escaneado en el campo de texto
            self.captureSession.stopRunning()
            //BEEP
            audioPlayer?.play()

            codigoExisteEnBaseDeDatos(barcode: codeValue) { (codigoExiste) in
                if codigoExiste {
                    self.performSegue(withIdentifier: "filtradosegue", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "iralregistroSegue", sender: nil)
                    if let presentingVC = self.presentingViewController as? listaViewController {
                        presentingVC.scannedCode = codeValue
                        print("no existe!")
                        presentingVC.codelabel.text = codeValue
                    }
                }
            }}

            }
    
        }

