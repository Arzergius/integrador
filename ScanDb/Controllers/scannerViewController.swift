import UIKit
import AVFoundation

class scannerViewController: UIViewController {

    @IBOutlet weak var barnumbertextfield: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar la sesión de captura
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        // Configurar la salida de metadatos
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13]
        
        // Configurar la capa de vista previa
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        
        // Calcular el tamaño y la posición de la capa de vista previa
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        let previewWidth = screenWidth
        let previewHeight = screenHeight / 3
        let previewX: CGFloat = 0
        let previewY: CGFloat = navigationController?.navigationBar.frame.maxY ?? 0
        
        previewLayer.frame = CGRect(x: previewX, y: previewY, width: previewWidth, height: previewHeight)
        
        // Agregar la capa de vista previa a la vista
        previewView.layer.addSublayer(previewLayer)
        
        // Comenzar la captura de video
        captureSession.startRunning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "iralregistroSegue"{
            if let destinoVC = segue.destination as? registroArticuloViewController {
                destinoVC.scannedCode = barnumbertextfield.text
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
            
            // Asignar el valor del código escaneado al scannedCode del listaViewController
            if let presentingVC = presentingViewController as? listaViewController {
                presentingVC.scannedCode = codeValue
                
                // Actualizar el valor del código en la etiqueta del listaViewController
                presentingVC.codelabel.text = codeValue
            }
            
            // El valor del código de barras escaneado
            print(codeValue)
        }
    }
}
