//
//  PokemonDetailsView.swift
//  hello-world
//
//  Created by Taylor on 8/24/22.
//

import UIKit

class PokemonDetailsView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style){
        super.init(frame: frame, style: style)
            self.addCustomDetailsView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func addCustomDetailsView() {
            
        }
}
