//
//  DBService.swift
//  camp
//
//  Created by 小黒皓太 on 2023/02/22.
//

import Foundation
import SQLite3

final class DBService {
    static let shared = DBService()
    
    private let dbFile = "DBVer1.sqlite"
    private var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        if !createTable() {
            print("Failed to create table")
        }
    }
    
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent(dbFile)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Failed to open database")
            return nil
        }
        else {
            print("Opened connection to database")
            return db
        }
    }
    
    private func createTable() -> Bool {
        let createSql = """
        CREATE TABLE IF NOT EXISTS place (
            place_id INTEGER NOT NULL PRIMARY KEY,
            place_name TEXT NOT NULL,
            ido_min INTEGER NOT NULL,
            ido_max INTEGER NOT NULL,
            keido_min INTEGER NOT NULL,
            keido_max INTEGER NOT NULL,
            count INTEGER NOT NULL,
            info TEXT NOT NULL,
            ido INTEGER NOT NULL,
            keido INTEGER NOT NULL
        );
        """
        
        var createStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (createSql as NSString).utf8String, -1, &createStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(createStmt)
            return false
        }
        
        sqlite3_finalize(createStmt)
        return true
    }
    
    private func getDBErrorMessage(_ db: OpaquePointer?) -> String {
        if let err = sqlite3_errmsg(db) {
            return String(cString: err)
        } else {
            return ""
        }
    }
    
    func insertStudent(place: Place) -> Bool {
        let insertSql = """
                        INSERT INTO place
                            (place_id, place_name, ido_min, ido_max, keido_min, keido_max, count, info, ido, keido)
                            VALUES
                            (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
                        """;
        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_int(insertStmt, 1,Int32(place.PlaceID))
        sqlite3_bind_text(insertStmt, 2, (place.PlaceName as NSString).utf8String, -1, nil)
        sqlite3_bind_int(insertStmt, 3,Int32(place.IdoMin))
        sqlite3_bind_int(insertStmt, 4,Int32(place.IdoMax))
        sqlite3_bind_int(insertStmt, 5,Int32(place.KeidoMin))
        sqlite3_bind_int(insertStmt, 6,Int32(place.KeidoMax))
        sqlite3_bind_int(insertStmt, 7,Int32(place.Count))
        sqlite3_bind_text(insertStmt, 8, (place.Info as NSString).utf8String, -1, nil)
        sqlite3_bind_int(insertStmt, 9,Int32(place.Ido))
        sqlite3_bind_int(insertStmt, 10,Int32(place.Keido))
        
        
        if sqlite3_step(insertStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(insertStmt)
            return false
        }
        sqlite3_finalize(insertStmt)
        return true
    }
    
    func getStudent(placeId: Int) -> (success: Bool, errorMessage: String?, placet: Place?) {
     
        var place: Place? = nil
        
        let sql = """
            SELECT  place_id, place_name, ido_min, ido_max, keido_min, keido_max, count, info, ido, keido
            FROM    place
            WHERE   place_id = ?;
            """
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            return (false, "Unexpected error: \(getDBErrorMessage(db)).", place)
        }
        
        sqlite3_bind_int(stmt, 1, Int32(placeId))
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let placeID = Int(sqlite3_column_int(stmt, 0))
            let placeName = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            let idoMin = Int(sqlite3_column_int(stmt, 2))
            let idoMax = Int(sqlite3_column_int(stmt, 3))
            let keidoMin = Int(sqlite3_column_int(stmt, 4))
            let keidoMax = Int(sqlite3_column_int(stmt, 5))
            let count = Int(sqlite3_column_int(stmt, 6))
            let info = String(describing: String(cString: sqlite3_column_text(stmt, 7)))
            let ido = Int(sqlite3_column_int(stmt, 8))
            let keido = Int(sqlite3_column_int(stmt, 9))
            
            
            place = Place(placeID: placeID, placeName: placeName,
                          idoMin: idoMin, idoMax: idoMax, keidoMin: keidoMin, keidoMax: keidoMax, count: count, info: info, ido: ido, keido: keido)
        }
        
        sqlite3_finalize(stmt)
        return (true, nil, place)
    }
    
    func getStudent2(placeName: String) -> (success: Bool, errorMessage: String?, placet: Place?) {
     
        var place: Place? = nil
        
        let sql = """
            SELECT  place_id, place_name, ido_min, ido_max, keido_min, keido_max, count, info, ido, keido
            FROM    place
            WHERE   place_name = ?;
            """
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            return (false, "Unexpected error: \(getDBErrorMessage(db)).", place)
        }
        
        sqlite3_bind_text(stmt, 1, (placeName as NSString).utf8String, -1, nil)
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let placeID = Int(sqlite3_column_int(stmt, 0))
            let placeName = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            let idoMin = Int(sqlite3_column_int(stmt, 2))
            let idoMax = Int(sqlite3_column_int(stmt, 3))
            let keidoMin = Int(sqlite3_column_int(stmt, 4))
            let keidoMax = Int(sqlite3_column_int(stmt, 5))
            let count = Int(sqlite3_column_int(stmt, 6))
            let info = String(describing: String(cString: sqlite3_column_text(stmt, 7)))
            let ido = Int(sqlite3_column_int(stmt, 8))
            let keido = Int(sqlite3_column_int(stmt, 9))
            
            
            place = Place(placeID: placeID, placeName: placeName,
                          idoMin: idoMin, idoMax: idoMax, keidoMin: keidoMin, keidoMax: keidoMax, count: count, info: info, ido: ido, keido: keido)
        }
        
        sqlite3_finalize(stmt)
        return (true, nil, place)
    }
    
    func updateStudent(place: Place) -> Bool {
        let updateSql = """
        UPDATE  place
        SET     place_name = ?,
                ido_min = ?,
                ido_max = ?,
                keido_min = ?,
                keido_max = ?,
                count = ?,
                info = ?,
                ido = ?,
                keido = ?
        WHERE   place_id = ?
        """
        
        var updateStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (updateSql as NSString).utf8String, -1, &updateStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_text(updateStmt, 1, (place.PlaceName as NSString).utf8String, -1, nil)
        sqlite3_bind_int(updateStmt, 2,Int32(place.IdoMin))
        sqlite3_bind_int(updateStmt, 3,Int32(place.IdoMax))
        sqlite3_bind_int(updateStmt, 4,Int32(place.KeidoMin))
        sqlite3_bind_int(updateStmt, 5,Int32(place.KeidoMax))
        sqlite3_bind_int(updateStmt, 6,Int32(place.Count))
        sqlite3_bind_text(updateStmt, 7, (place.Info as NSString).utf8String, -1, nil)
        sqlite3_bind_int(updateStmt, 8,Int32(place.Ido))
        sqlite3_bind_int(updateStmt, 9,Int32(place.Keido))
        
        sqlite3_bind_int(updateStmt, 10, Int32(place.PlaceID))
        
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(updateStmt)
            return false
        }
        sqlite3_finalize(updateStmt)
        return true
    }
}
