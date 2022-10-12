//
//  HTTPClient.swift
//  hello-world
//
//  Created by Taylor on 8/24/22.
//

import Foundation
import UIKit

final class HTTPClient{
    
    struct PokemonArray: Decodable {
        let results: [[String:String]]
    }
    
    var targetLimit = 9
    var targetOffset = 0
    
    func setTargetLimit(newLimit:Int) {
        targetLimit = newLimit
    }
    func setTargetOffset(newOffset:Int) {
        targetOffset = newOffset
    }
    
    func getPokemonFromAPI(arrayOfNamesForPokemonAlreadyInDb: [String]) async -> [Pokemon] {
        var pokemon: [Pokemon] = []
            do {
                let pokemonArray = try await self.getPokemonArray()
                let urlsArray =  self.getUrlsArrayFromPokemonArray(pokemonArray: pokemonArray, arrayOfNamesForPokemonAlreadyInDb: arrayOfNamesForPokemonAlreadyInDb)
                let usablePokemon = try await self.getUsablePokemonArrayFromUrlsArray(urlsArray: urlsArray)
                pokemon = usablePokemon
            } catch {
                print("error :", error)
            }
       return pokemon
    }
    
    func getPokemonArray() async throws -> [[String : String]] {
        
        let targetUrl = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(targetLimit)&offset=\(targetOffset)")!
        
        let (data, _) = try await URLSession.shared.data(from: targetUrl)
        let decodedPokemon = try JSONDecoder().decode(PokemonArray.self, from: data)
        return decodedPokemon.results
    }
    
    func getUrlsArrayFromPokemonArray(pokemonArray: [[String : String]], arrayOfNamesForPokemonAlreadyInDb: [String]) -> [String]{
        var urlsArray: [String] = []
        for pokemon in pokemonArray {
            let alreadyInDb = (arrayOfNamesForPokemonAlreadyInDb.contains(pokemon["name"]!))
            if !alreadyInDb {
                print("adding image url request for", pokemon["name"]!)
                urlsArray.append(pokemon["url"]!)
            }
        }
        return urlsArray
    }
    
    func getUsablePokemonArrayFromUrlsArray(urlsArray: [String]) async throws -> [Pokemon] {
        var usablePokemonArray: [Pokemon] = []
        for url in urlsArray {
            let pokemonUrl = URL(string: url)!
            let (data, _) = try await URLSession.shared.data(from: pokemonUrl)
            let decodedUsablePokemon = try JSONDecoder().decode(Pokemon.self, from: data)
            usablePokemonArray.append(decodedUsablePokemon)
        }
        return usablePokemonArray
    }
    
    func getImagesFromApi(pokemonArray: [Pokemon]) async {
        for pokemon in pokemonArray {
            do {
                let dir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let fileUrl = dir.appendingPathComponent(String(pokemon.id)).appendingPathExtension("png")
                if FileManager.default.fileExists(atPath: fileUrl.path){
//                    print("img already exists for", pokemon.name)
                } else {
                    let imgUrl = URL(string: pokemon.img)!
                    let (data, _) = try await URLSession.shared.data(from: imgUrl)
                    let filePath = "file://\(fileUrl.path)"
                    do {
                        try data.write(to: URL(string: filePath)!)
                    } catch {
                        print("File writing failed: ", error)
                    }
                }
            } catch {
                print("Error with file path: ", error)
            }
        }
    }
    
}
