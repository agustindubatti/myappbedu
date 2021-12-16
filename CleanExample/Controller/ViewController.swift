//
//  ViewController.swift
//  CleanExample
//
//  Created by Agustin Dubatti on 20/10/2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let model: Registered = Registered()
    var tipoError: Int = 0
    //Outlets
    @IBOutlet weak var logIn: UILabel!
    @IBOutlet weak var enterEmail: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    
    ///Verifica si el usuario y la password son validos, de ser asi ingresa a la app
    @IBAction func `continue`(_ sender: Any) {
        
        guard let userString = username.text, userString.count > 0 else{
            print("Email vacio")
            tipoError = 1
            return
        }
        
        guard userString.isValidEmail(), userString.count >= 10 else{
            print("El email no cumple con el formato requerido")
            tipoError = 2
            return
        }
        
        guard let passString = password.text, passString.count > 0 else{
            print("Password vacia")
            tipoError = 3
            return
        }
        guard passString.count <= 10 else{
            print("Password con mas de 10 caracteres")
            tipoError = 4
            return
        }
        
            if model.user1.user == userString && model.user1.pass == passString {
                savedData()
                downloadTracks()
                goToMainController()
                /*RestServiceManager.shared.getToServer(responseType: [Song].self, method: .get, endpoint: "songs") {
                    status, data in
                           misTracks = [Song]()
                           if let _data = data {
                               misTracks = _data
                               //self.tableView.reloadData()
                           }
                       }*/
                print(misTracks)
                print ("AUTH OK")
            }else{
                username.errorAnimated()
                password.errorAnimated()
                print ("Usuario o contraseña incorrecto")
            }

        
    }
    
    
    ///Boton que lleva a la Register View
    @IBAction func singUp(_ sender: UIButton) {
        goToRegisterController()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "CustomBackgroundColor")
        username.startInController()
        password.startInController()
        
    }
    
    ///Manejo correcto del teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    ///Esta funcion va hacia la Main View
    func goToMainController() {
        /*let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainController") as? MainViewController
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)*/
        performSegue(withIdentifier: "loginOK", sender: self)
    }
    
    ///Esta funcion va hacia la musica
    func goToMyLibrary() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "myLibrary") as? TracksTableTableViewController
        
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)
    }
    
    ///Esta funcion va hacia la Register View
    func goToRegisterController() {
        /*let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerController") as? RegisterViewController
        
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)*/
        performSegue(withIdentifier: "register", sender: self)
    }
    
    func savedData() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.managedObjectContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tracklist")
            request.returnsObjectsAsFaults = false
            
            do {
                let result = try context!.fetch(request) // fetch nos da elementos no nulos
                misTracks = [Song]()
                
                for data in result as! [NSManagedObject] {
                    let title = data.value(forKey: "title") as? String
                    let artist = data.value(forKey: "artist") as? String
                    let song_id = data.value(forKey: "song_id") as? String
                    let album = data.value(forKey: "album") as? String
                    let genre = data.value(forKey: "genre") as? String
                    
                    let track = Song(title: title ?? "",
                                      artist: artist ?? "",
                                      album: album ?? "",
                                     song_id: song_id ?? "",
                                      genre: genre ?? ""
                    )
                    misTracks.append(track)
                }
                
            } catch {
                print("Falle al obtener info de la BD \(error), \(error.localizedDescription)")
            }
            
    //        if false {
            self.downloadTracks()
    //        }
            
        }
    
    func downloadTracks() {
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
          let context = appDelegate.managedObjectContext
          
          RestServiceManager.shared.getToServer(responseType: [Song].self, method: .get, endpoint: "songs") { status, data in
              misTracks = [Song]()
              if let _data = data {
                  misTracks = _data
                  if let _context = context {
                      // Eliminar contenido
                      let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Tracklist")
                      let deleteRquest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                      do {
                          try appDelegate.persistentStoreCoordinator?.execute(deleteRquest, with: _context)
                      } catch {
                          print(error)
                      }
                      //Fin eliminar contenido
                      
                      //Agregar contenido a CoreData
                      for item in _data {
                          let tracksEntity = NSEntityDescription.insertNewObject(forEntityName: "Tracklist", into: _context)
                          tracksEntity.setValue(item.artist, forKey: "artist")
                          tracksEntity.setValue(item.title, forKey: "title")
                          tracksEntity.setValue(item.song_id , forKey: "song_id")
                          tracksEntity.setValue(item.genre, forKey: "genre")
                          tracksEntity.setValue(item.album, forKey: "album")
                          
                          do {
                              try context?.save()
                          } catch {
                              print("No se guardo la info \(error), \(error.localizedDescription)" )
                          }
                      }
                  }
              }
          }
      }
    
    
    
    
    
}
