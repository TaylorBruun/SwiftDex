//
//  dbManager.swift
//  hello-world
//
//  Created by Taylor on 8/31/22.
//

import Foundation
import SQLite3

final class DbManager {
    
    enum QueryError: Error{
        case nilResult
    }
    
    func openDatabase() -> OpaquePointer? {
        var dbPathUrl: URL? = nil
     
        do {
            dbPathUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension("pokemonDb.sqlite")
        } catch {
            print("error with dbPath, ensure that this is the correct path to the database: ", dbPathUrl!)
        }

      var db: OpaquePointer?
      
        if sqlite3_open(dbPathUrl?.path, &db) != SQLITE_OK {
            print("Unable to open database.")
            return nil
      } else {
          print("Successfully opened connection to database at: ", dbPathUrl!)
      }
        return db
    }
    
    func closeDatabase(db: OpaquePointer?){
        sqlite3_close(db)
    }

    func createTable(db: OpaquePointer?){
        let sql = """
        CREATE TABLE IF NOT EXISTS pokemon(
        id INT PRIMARY KEY NOT NULL,
        name VARCHAR(255),
        height FLOAT,
        weight FLOAT,
        img VARCHAR(255));
        """
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Pokemon table created")
            } else {
                print("Failure to create Pokemon table")
            }
        } else {
            print("Error in create table SQL")
        }
        sqlite3_finalize(createTableStatement)
    }
    
        
    func insertToPokemonTable(db: OpaquePointer?, pokemonArray: [Pokemon]){

        let sql = """
        INSERT INTO pokemon(id, name, height, weight, img) VALUES (?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?

        for pokemon in pokemonArray {
        
            let cName = NSString(string: pokemon.name)
            let cImg = NSString(string: pokemon.img)

            if sqlite3_prepare_v2(db, sql, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(pokemon.id))
                sqlite3_bind_text(insertStatement, 2, cName.utf8String, -1, nil)
                sqlite3_bind_double(insertStatement, 3, Double(pokemon.height))
                sqlite3_bind_double(insertStatement, 4, Double(pokemon.weight))
                sqlite3_bind_text(insertStatement, 5, cImg.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row for", pokemon.name)
                } else {
                    print("Could not insert row")
                }
            } else {
                print("Error in SQL statement")
            }
            sqlite3_reset(insertStatement)
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    func dropTable(db: OpaquePointer?){
        let sql = "DROP TABLE pokemon"
        
        var queryStatement: OpaquePointer?
        
        sqlite3_prepare_v2(db, sql, -1, &queryStatement, nil)
        sqlite3_step(queryStatement)
        sqlite3_finalize(queryStatement)
        print("table deleted")
    }
    
    
    func retrieveAll(db: OpaquePointer?) throws -> [Pokemon] {
        let sql = "SELECT * FROM pokemon;"
        
        var queryStatement: OpaquePointer?
        var pokemonArray: [Pokemon] = []
        
        if sqlite3_prepare_v2(db, sql, -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let id = sqlite3_column_int(queryStatement, 0)
                guard let queryResultName = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil")
                    throw QueryError.nilResult
                }
                let name = String(cString: queryResultName)
                let height = sqlite3_column_double(queryStatement, 2)
                let weight = sqlite3_column_double(queryStatement, 3)
                guard let queryResultImg = sqlite3_column_text(queryStatement, 4) else {
                    print("Query result is nil")
                    throw QueryError.nilResult
                }
                let img = String(cString: queryResultImg)
                pokemonArray.append(Pokemon(id: Int(id), name: name, height: Float(height), weight: Float(weight), img: img))
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Query is not prepared", errorMessage)
        }
        sqlite3_finalize(queryStatement)
        return pokemonArray
    }
 
    func retrieveAllNames(db: OpaquePointer?) throws -> [String] {
        let sql = "SELECT name FROM pokemon;"
        
        var queryStatement: OpaquePointer?
        var namesArray: [String] = []

        if sqlite3_prepare_v2(db, sql, -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                guard let queryResultName = sqlite3_column_text(queryStatement, 0) else {
                    print("Query result is nil")
                    throw QueryError.nilResult
                }
                let name = String(cString: queryResultName)
                namesArray.append(name)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Query is not prepared", errorMessage)
        }
//        print("returning this array from names check:", namesArray)
        sqlite3_finalize(queryStatement)
        return namesArray
    }
    
}
