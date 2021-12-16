//
//  AudioPlayerController.swift
//  CleanExample
//
//  Created by Agustin Dubatti on 05/11/2021.
//

import UIKit
import SwiftySound
import AudioPlayer

class AudioPlayerViewController: UIViewController {
    
    var isPlaying = true
    var mySound: AudioPlayer?
    
    var timer: Timer?
    var porcentualCancion: Double?
    
    var sliderTrack = UISlider()
    
    var songName: String?
    
    var model: AudioCellModel?
    
    var tableView: UITableView = UITableView()
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        isPlaying = !(isPlaying)
        if isPlaying {
            print ("Playing Music")
            mySound?.play()
        }
        else {
            print ("Noy playing Music")
            mySound?.stop()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        do {
            
            mySound = try AudioPlayer(fileName: "bensound-ukulele.mp3")
            mySound?.play()
            isPlaying = true
            porcentualCancion = (1.0 / Double(mySound!.duration))
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSongSlider), userInfo: nil, repeats: true)
            
            
        } catch {
            
            print("Sound initialization failed")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mySound?.stop()
        isPlaying = false
        model?.delegate.updateState()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let labelReproductor=UILabel()
        labelReproductor.text=model?.songName
        labelReproductor.font=UIFont.systemFont(ofSize: 24)
        labelReproductor.autoresizingMask = .flexibleWidth
        labelReproductor.translatesAutoresizingMaskIntoConstraints=true
        labelReproductor.frame=CGRect(x: 0, y: 50, width: self.view.frame.width, height: 50)
        labelReproductor.textAlignment = .center
        self.view.addSubview(labelReproductor)
        
        let playButton=UIButton(type: .system)
        playButton.setTitle("Play", for: .normal)
        playButton.autoresizingMask = .flexibleWidth
        playButton.translatesAutoresizingMaskIntoConstraints=true
        playButton.frame=CGRect(x: 20, y: 100, width: 100, height: 40)
        self.view.addSubview(playButton)
        playButton.addTarget(self, action: #selector(self.botonPlayTouch(_:)), for: .touchUpInside)
        
        let menuButton=UIButton(type: .system)
        menuButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        menuButton.autoresizingMask = .flexibleWidth
        menuButton.translatesAutoresizingMaskIntoConstraints=true
        menuButton.frame=CGRect(x: self.view.frame.width/2, y: 100, width: 100, height: 40)
        self.view.addSubview(menuButton)
        menuButton.addAction(UIAction(title: "", handler: { (_) in
            print("Accion Default")
        }), for: .touchUpInside)
        menuButton.menu = addMenuItems()
        
        
        let stopButton=UIButton(type: .system)
        stopButton.setTitle("Stop", for: .normal)
        stopButton.autoresizingMask = .flexibleWidth
        stopButton.translatesAutoresizingMaskIntoConstraints=true
        stopButton.frame=CGRect(x: self.view.frame.width-100, y: 100, width: 100, height: 40)
        self.view.addSubview(stopButton)
        stopButton.addTarget(self, action: #selector(self.botonStopTouch(_:)), for: .touchUpInside)
        
        sliderTrack.autoresizingMask = .flexibleWidth
        sliderTrack.translatesAutoresizingMaskIntoConstraints=true
        sliderTrack.frame=CGRect(x: 20, y:150, width: self.view.frame.width-40, height: 50)
        self.view.addSubview(sliderTrack)
        sliderTrack.addTarget(self, action: #selector(self.slider1Touch(_:)), for: .valueChanged)
        
        let labelVolumen=UILabel()
        labelVolumen.text="Volumen"
        labelVolumen.autoresizingMask = .flexibleWidth
        labelVolumen.translatesAutoresizingMaskIntoConstraints=true
        labelVolumen.frame=CGRect(x: 20, y: 200, width: 100, height: 40)
        self.view.addSubview(labelVolumen)
        
        let sliderVolumen=UISlider()
        sliderVolumen.autoresizingMask = .flexibleWidth
        sliderVolumen.translatesAutoresizingMaskIntoConstraints=true
        sliderVolumen.frame=CGRect(x: 20, y: 250, width: self.view.frame.width/2, height: 50)
        sliderVolumen.value = 1
        self.view.addSubview(sliderVolumen)
        sliderVolumen.addTarget(self, action: #selector(self.slider2Touch(_:)), for: .valueChanged)
        
        if let laURL = Bundle.main.url(forResource: "stegosaurus-studio", withExtension: ".gif") {
            let elGIF = UIImage.animatedImage(withAnimatedGIFURL: laURL)
            let imgContainer = UIImageView(image: elGIF)
            imgContainer.autoresizingMask = .flexibleWidth
            imgContainer.translatesAutoresizingMaskIntoConstraints=true
            imgContainer.frame=CGRect(x: 0, y: 350, width: self.view.frame.width, height: 150)
            self.view.addSubview(imgContainer)
        }
    }
    
    @objc func botonPlayTouch(_ sender:UIButton!) {
        print("Play button")
        //mySound?.stop() //Porque si no se pisa
        mySound?.play()
    }
    
    @objc func botonStopTouch(_ sender:UIButton!) {
        print("Stop button")
        mySound?.stop()
        timer?.invalidate()
        timer = nil
    }
    @objc func slider1Touch(_ sender:UISlider!) {
        print("Player slider adjusted on \(sender.value)")
        mySound?.currentTime = TimeInterval(Double(mySound!.duration) * Double (sender.value))
        mySound?.play()
        
    }
    
    @objc func slider2Touch(_ sender:UISlider!) {
        print("Volume slider adjusted on \(sender.value)")
        mySound?.volume = sender.value
    }
    
    @objc func updateSongSlider(){
        sliderTrack.value += Float (porcentualCancion!)
        
        if(sliderTrack.value == 1.0){
            mySound?.stop()
            sliderTrack.value = 0
            timer?.invalidate()
            timer = nil
        }
    }
    
    func addMenuItems() -> UIMenu{
        let accionesDiccionario = [OpcionesMenu.trash: eliminar, OpcionesMenu.share: compartir, OpcionesMenu.download: descargar]
    
        var items = [UIAction]()
        //let items = BtnOpciones.allCases
        
        for opcion in OpcionesMenu.allCases {
            items.append(.init(title: opcion.title, image: opcion.imagen, handler: {_ in
                accionesDiccionario[opcion]?()
            }))
        }
        return .init(title: "", image: nil, children: items)
    }
    
    func eliminar() -> Void {
        let cancionABorrar = misTracks.firstIndex(where: {$0.title == model?.songName})
        misTracks.remove(at : cancionABorrar!)
        self.showSimplePopUpAlert("Borrado","Se ha borrado la cancion \(model?.songName ?? "")")
        //self.dismiss(animated: false)
    }
    
    func compartir() -> Void {
        let song = model?.songName
        //self.showSimplePopUpAlert("Compartir","Se ha compartido la cancion \(song ?? "")")
        
        let shareVC = UIActivityViewController(
            activityItems: [song ?? "value"],
        applicationActivities: nil
        )
        
        present(shareVC, animated: true)
        //self.dismiss(animated: false)
    }
    
    func descargar() -> Void{
        DownloadManager.shared.startDownload(url: URL(string: "https://speed.hetzner.de/100MB.bin")!)
    }
    
    
}
