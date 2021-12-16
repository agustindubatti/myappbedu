//
//  HighlightButton.swift
//  CleanExample
//
//  Created by Agustin Dubatti on 01/12/2021.
//

import UIKit

class playStopButton: UIButton {
    
    var icon : UIImage?
    var secondIcon : UIImage?
    var isPlaying : Bool = false
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.tintColor = .systemGreen
    }
    
    func performTwoStateSelection() {
        self.isPlaying = !isPlaying
        self.setImage(isPlaying ? icon : secondIcon, for: .normal)
        self.setImage(isPlaying ? icon : secondIcon, for: .highlighted)
    }
    
    func setImage(icon: UIImage?) {
        guard let icon = icon else { return }
        self.icon = icon
        self.setImage(icon, for: .normal)
        self.setImage(icon, for: .highlighted)
    }

    
    

}
