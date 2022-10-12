//
//  PokemonView.swift
//  hello-world
//
//  Created by Taylor on 8/24/22.
//



import UIKit

class PokemonGallaryView: UIScrollView{

private var imgView: UIImageView!
private var indicatorView: UIActivityIndicatorView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.addCustomGallaryView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomGallaryView() {
        self.showsHorizontalScrollIndicator = true
        self.isDirectionalLockEnabled = true
        self.canCancelContentTouches = true
        self.translatesAutoresizingMaskIntoConstraints = false

    }
}
