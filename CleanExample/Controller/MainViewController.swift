//
//  MainViewController.swift
//  CleanExample
//
//  Created by Agustin Dubatti on 29/10/2021.
//

import UIKit

class MainViewController: UIViewController {


    //Outlets
    @IBOutlet weak var labelBienvenido: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    
    
    ///Dismiss button que vuelve a la vista anterior
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Asignacion de la imagen
        imagen.image = UIImage(named: "unaImagen")
        
        
        gestures()
        
        
    }
    
    
    func gestures() {
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            let gesturePinch = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
            self.imagen.addGestureRecognizer(gestureTap)
            self.imagen.addGestureRecognizer(gesturePinch)
            self.imagen.isUserInteractionEnabled = true
        }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let compilado = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
            let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""

        showSimplePopUpAlert("Version", "Version: \(version)\n Compilado: \(compilado)\n \(appName)")
        
    }
    
    @objc func didPinch(_ sender: UIPinchGestureRecognizer) {
            if let scale = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)) {
                       guard scale.a > 1.0 else { return }
                       guard scale.d > 1.0 else { return }
                        sender.view?.transform = scale
                       sender.scale = 1.0
            }
        }

    

}
