//
//  PersistencyManager.swift
//  hello-world
//
//  Created by Taylor on 8/24/22.
//

import Foundation

final class PersistencyManager {
    private var pokemon = [Pokemon]()
    private var registeredPokemon = [Int]()
    private var currentPokemonIndex = 0
    
    
    
    // The API acually gives back height 5 and weight 90 for squirtle.... it is in decimeters and hectograms.....
    init (){
        pokemon.reserveCapacity(1024)
    }
    
    
    
    func getPokemon () -> [Pokemon] {
        return pokemon
    }
    
    func setPokemon(pokemonArray:[Pokemon]){
        let sortedArray = pokemonArray.sorted {
            $0.id < $1.id
        }
        pokemon = sortedArray
    }
    
    func getCurrentPokemonIndex() -> Int {
        return currentPokemonIndex
    }
    
    func setCurrentPokemonIndex(index: Int) {
        currentPokemonIndex = index
    }
    
    func registerPokemon (_ targetPokemonId: Int){
        var found = false
        for pokemonId in registeredPokemon{
            if pokemonId == targetPokemonId{
                found = true
            }
        }
        if found == false {
            registeredPokemon.append(targetPokemonId)
        }
    }
    
}
