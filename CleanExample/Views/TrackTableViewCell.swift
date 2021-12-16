//
//  TrackTableViewCell.swift
//  CleanExample
//
//  Created by Agustin Dubatti on 09/11/2021.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    var track:Song?
    var parent:ButtonOnCellDelegate?
    
    var icon: UIImage?
    var secondIcon: UIImage?
    var isPlaying: Bool = false
    
    var icono: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "nota")
        imgView.backgroundColor = .white
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var titulo: UILabel = {
        var lbl = UILabel()
        lbl.textColor = .white
        lbl.text = "Song"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    var artista: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.text = "Album"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var botonPlay: playStopButton = {
        let btn = playStopButton()
        btn.icon = UIImage(named: "play")
        btn.secondIcon = UIImage(named: "pause")
        btn.performTwoStateSelection()
        btn.setImage(UIImage(named: "play"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, track: Song?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.track = track
        titulo.text = self.track!.title
        artista.text = self.track!.artist
        addSubview(icono)
        NSLayoutConstraint.activate([
            icono.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            icono.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            icono.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            icono.widthAnchor.constraint(equalTo: icono.heightAnchor)
        ])
        addSubview(botonPlay)
        NSLayoutConstraint.activate([
            botonPlay.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            botonPlay.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            botonPlay.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            botonPlay.widthAnchor.constraint(equalTo: botonPlay.heightAnchor)
        ])
        addSubview(titulo)
        NSLayoutConstraint.activate([
            titulo.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titulo.heightAnchor.constraint(equalToConstant: 35),
            titulo.leadingAnchor.constraint(equalTo: icono.trailingAnchor, constant: 5),
            titulo.trailingAnchor.constraint(equalTo: botonPlay.leadingAnchor, constant: -5)
        ])
        addSubview(artista)
        NSLayoutConstraint.activate([
            artista.heightAnchor.constraint(equalToConstant: 35),
            artista.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            artista.leadingAnchor.constraint(equalTo: icono.trailingAnchor, constant: 5),
            artista.trailingAnchor.constraint(equalTo: botonPlay.leadingAnchor, constant: -5)
        ])
        contentView.isUserInteractionEnabled = false
        botonPlay.addTarget(self, action: #selector(self.botonPlayTouch(_ :)), for:.touchUpInside)
    }
    
    @objc func botonPlayTouch(_ sender:UIButton!) {
        botonPlay.performTwoStateSelection()
        guard let botonPlay = parent else {
            return
        }
        botonPlay.buttonTouchedOnCell(aCell: .init(delegate: self, songName: titulo.text ??  ""))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

extension TrackTableViewCell : CelDelegate {
    func updateState() {
        botonPlay.performTwoStateSelection()
    }
}
