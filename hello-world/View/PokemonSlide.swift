//
//  PokemonSlide.swift
//  hello-world
//
//  Created by Taylor on 8/25/22.
//

import UIKit

class PokemonSlide: UIView{
    private var imgView = UIImageView()
    public var textLabel = UILabel()
    public var allButton = UIButton()
    

    
    private var myIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomSlideView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomSlideView() {
        imgView.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        self.addSubview(imgView)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textLabel)
        allButton.translatesAutoresizingMaskIntoConstraints = false
        allButton.layer.cornerRadius = 55
        self.addSubview(allButton)
        
        allButton.addTarget(self, action: #selector(setMyIndexToCurrent), for: .touchUpInside)
        
        NSLayoutConstraint.activate([

            allButton.topAnchor.constraint(equalTo: self.topAnchor),
            allButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            allButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            allButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            allButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    func setTitle(string: String){
        self.textLabel.text = string
    }
    
    func setImg(id: Int){
        do {
            let dir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileUrl = dir.appendingPathComponent(String(id)).appendingPathExtension("png")
            let filePath = "file://\(fileUrl.path)"
            let data = try Data(contentsOf: URL(string: filePath)!)
            self.imgView.image = UIImage(data: data)
            
        } catch {
            print("error setting slide img: ", error)
        }
        
    }
    
    func setIndex(index: Int){
        self.myIndex = index
    }
    
   @objc func setMyIndexToCurrent(){
        PokedexAPI.shared.setCurrentPokemonIndex(index: myIndex)
    }
    
    
    
}
