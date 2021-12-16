//
//  RegisterViewController.swift
//  CleanExample
//
//  Created by Agustin Dubatti on 02/11/2021.
//

import UIKit


class RegisterViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var singUp: UILabel!
    @IBOutlet weak var enterEmail: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var singUpUsingSocialApp: UILabel!
    
    
    ///Verifica si el usuario y la password son validos, de ser asi ingresa a la app
    @IBAction func register(_ sender: Any) {
        var usernameOk = false
        
        guard let username = username.text else {
            print ("ERROR - No se tiene username")
            return
        }
       
        
        if username != "" {
            if username.count >= 10 {
                var tieneArroba = false
                for caracter in username {
                    if caracter == "@" {
                        tieneArroba = true
                    }
                }
                if tieneArroba {
                    print ("El usuario tiene mas de 10 caracteres y tiene arroba")
                    usernameOk = true
                    
                }else{
                    print ("El usuario tiene mas de 10 caracteres pero no arroba")
                    //tipoError = 2
                }
                
            }else{ print ("El usuario debe tener al menos 10 caracteres")
                //tipoError = 2
                
            }
            
        }else {
            print ("El usuario no puede estar vacío")
            //tipoError = 1
        }
        
        
                
        
        if usernameOk  {
            goToMainController()
            print ("AUTH OK")
        }
        
    }
    
    
    ///Dismiss del RegisterView Controller
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    ///Al tocarse el boton, cambia de color al accent
    @IBAction func facebookButton(_ sender: UIButton) {
        
        (sender as UIButton).backgroundColor = UIColor(named: "AccentColor")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "CustomBackgroundColor")
        
        
        //Algunos cambios de color utilizando el Accent Color
        enterEmail.textColor = UIColor(named: "AccentColor")
        singUpUsingSocialApp.textColor = UIColor(named: "AccentColor")
    }
    
    
    
    ///Manejo correcto del teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    ///Esta funcion va hacia la Main View
    func goToMainController() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainController") as? MainViewController
        
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)
    }

    
    


}
