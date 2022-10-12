//
//  PokedexAPI.swift
//  hello-world
//
//  Created by Taylor on 8/24/22.
//

import Foundation


final class PokedexAPI {
    static let shared = PokedexAPI()

    private let persistencyManager = PersistencyManager()
    private let httpClient = HTTPClient()
    private let dbManager = DbManager()
    
    private init(){
        
//        let db = dbManager.openDatabase()
//        dbManager.dropTable(db: db)
//        dbManager.createTable(db: db)
//        dbManager.closeDatabase(db: db)
    }
    
    func insertToPokemonTable(pokemonArray: [Pokemon]){
        let db = dbManager.openDatabase()
        dbManager.insertToPokemonTable(db: db, pokemonArray: pokemonArray)
        dbManager.closeDatabase(db: db)
    }
    
    func setDbtoPersistencyManager(){
        let pokemon = try! self.retrieveAllFromDb()
        self.persistencyManager.setPokemon(pokemonArray: pokemon)
    }
    
    func retrieveAllFromDb() throws -> [Pokemon]{
        let db = dbManager.openDatabase()
        do {
            let pokemon = try dbManager.retrieveAll(db: db)
            dbManager.closeDatabase(db: db)
            return pokemon
        } catch {
            dbManager.closeDatabase(db: db)
            print("error: ", error)
            throw error
        }
        
    }
    
    func getPokemon() -> [Pokemon] {
        return persistencyManager.getPokemon()
    }
    
    
    func registerPokemon(_ pokemonId: Int){
        persistencyManager.registerPokemon(pokemonId)
    }
    
    func getPokemonFromAPI() async {
        let db = dbManager.openDatabase()
        var namesArray: [String] = []
        do {
            namesArray = try dbManager.retrieveAllNames(db: db)
        } catch {
            print("error retrieving namesArray: ", error)
        }
        var pokemon:[Pokemon] = await httpClient.getPokemonFromAPI(arrayOfNamesForPokemonAlreadyInDb: namesArray)
        self.insertToPokemonTable(pokemonArray: pokemon)
        try! pokemon = self.retrieveAllFromDb()
        persistencyManager.setPokemon(pokemonArray: pokemon)
        dbManager.closeDatabase(db: db)
    }
    
    func getImagesFromApi(pokemonArray: [Pokemon]) async {
        await httpClient.getImagesFromApi(pokemonArray: pokemonArray)
    }
    
    func getCurrentPokemonIndex() -> Int {
        persistencyManager.getCurrentPokemonIndex()
    }
    
    func setCurrentPokemonIndex(index: Int) {
        persistencyManager.setCurrentPokemonIndex(index: index)
    }
    
}
