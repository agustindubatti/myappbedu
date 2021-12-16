//
//  TracksTableTableViewController.swift
//  CleanExample
//
//  Created by Agustin Dubatti on 05/11/2021.
//

import UIKit


class TracksTableTableViewController: UITableViewController, ButtonOnCellDelegate {
    
    var timer: Timer?
    
    func buttonTouchedOnCell(aCell: AudioCellModel) {
        
        let apvc = AudioPlayerViewController()
        apvc.tableView = self.tableView
        apvc.model = aCell
        self.present(apvc, animated: true, completion: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*let callBack: ( [Song]?, Error? ) -> () = { canciones, error in
          if error != nil {
            print("No se pudo obtener la lista de canciones")
          }
          else {
            misTracks = canciones ?? []
            DispatchQueue.main.async {
              self.tableView.reloadData()
            }
          }
        }
        let api = APIManager()
        api.getMusic(completion: callBack)*/
        /*RestServiceManager.shared.getToServer(responseType: [Song].self, method: .get, endpoint: "songs") {
            status, data in
                   misTracks = [Song]()
                   if let _data = data {
                       misTracks = _data
                       self.tableView.reloadData()
                   }
               }*/

      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.black
        self.tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.rowHeight = 80
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(agregarCancionPorTimer),
                                               name: NSNotification.Name("updateTable"),
                                               object: nil)
        
      }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true){ t in
            NotificationCenter.default.post(name: NSNotification.Name("updateTable"), object: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return misTracks.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TrackTableViewCell
        //let track = misTracks[indexPath.row]
        let track = misTracks[indexPath.row]
        let cell = TrackTableViewCell(style: .default, reuseIdentifier: "reuseIdentifier", track: track)

        cell.backgroundColor = .clear
        
        cell.track = track
        cell.parent = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Mis canciones"

    }
    
    @objc func agregarCancionPorTimer(){
        
        print("Se llama la funcion de agregar por timer")
        
        let song: Song = Song(title:"Cancion Agregada",artist:"Artista", album:"Test", song_id:"99", genre: "Genero")
        
        
        if (!misTracks.contains{$0.title == "Cancion Agregada"}){
            misTracks.append(song)
            self.tableView.reloadData()
        }
    }



}
