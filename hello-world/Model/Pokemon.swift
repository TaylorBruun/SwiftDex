//
//  Pokemon.swift
//  hello-world
//
//  Created by Taylor on 8/24/22.
//

import Foundation

struct Pokemon {
    let id : Int
    let name : String
    let height : Float
    let weight : Float
    let img: String
}

extension Pokemon: Codable {
    
    enum OuterKeys: String, CodingKey {
        case id, name, height, weight, sprites
    }
    
    enum SpritesKeys: String, CodingKey {
        case other
    }
    
    enum OtherSpritesKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
    
    enum OfficialArtworkOtherSpritesKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
    
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        let spritesContainer = try outerContainer.nestedContainer(keyedBy: SpritesKeys.self, forKey: .sprites)
        let otherSpritesKeys = try spritesContainer.nestedContainer(keyedBy: OtherSpritesKeys.self, forKey: .other)
        let officialArtworkOtherSpritesKeys = try otherSpritesKeys.nestedContainer(keyedBy: OfficialArtworkOtherSpritesKeys.self, forKey: .officialArtwork)
        
        self.id = try outerContainer.decode(Int.self, forKey: .id)
        self.name = try outerContainer.decode(String.self, forKey: .name)
        self.height = try outerContainer.decode(Float.self, forKey: .height)
        self.weight = try outerContainer.decode(Float.self, forKey: .weight)
        self.img = try officialArtworkOtherSpritesKeys.decode(String.self, forKey: .frontDefault)
    }
}

typealias PokemonData = (name: String, value: String)

extension Pokemon {
    var tableRepresentation: [PokemonData] {
        return [
            ("Id", String(id)),
            ("Name", name),
            ("Height", String(height)),
            ("Weight", String(weight)),
            ("imgURL", img),
        ]
    }
}


