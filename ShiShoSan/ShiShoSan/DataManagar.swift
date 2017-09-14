//
//  DataBaseHelper.swift
//  ZWave
//
//  Created by ゴ　ハイ　バン on 2017/07/25.
//  Copyright © 2017 ゴ　ハイ　バン. All rights reserved.
//

import Foundation
import SQLite

class DataManagar{
    static let shared:DataManagar = DataManagar()
    private let db: Connection?
    private let id = Expression<String>("id")
    private let name = Expression<String?>("name")
    
    private let tblArea = Table("area")
    private let tblCity = Table("city")
    private let tblLine = Table("line")
    private let tblStation = Table("station")

    private let company = Expression<String?>("company")
    private let listStation = Expression<String?>("listStation")
    private let areaID = Expression<String?>("areaID")
    
    private init(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do{
            db = try Connection("\(path)/jlife.sqlite3")
            createTableArea()
            createTableCity()
            createTableLine()
            createTableStation()
        }catch{
            db = nil
            print ("Unable to open database")
        }
    }
    
    func createTableLine() {
        do {
            try db!.run(tblLine.create(ifNotExists: true) { table in
                table.column(id)
                table.column(name)
                table.column(listStation)
                table.column(company)
                table.column(areaID)
            })
        } catch {
        }
    }
    
    func createTableCity() {
        do {
            try db!.run(tblCity.create(ifNotExists: true) { table in
                table.column(id)
                table.column(name)
                table.column(areaID)
            })
        } catch {
        }
    }
    
    func createTableArea() {
        do {
            try db!.run(tblArea.create(ifNotExists: true) { table in
                table.column(id)
                table.column(name)
            })
        } catch {
        }
    }
    func createTableStation() {
        do {
            try db!.run(tblStation.create(ifNotExists: true) { table in
                table.column(id)
                table.column(name)
                table.column(areaID)
            })
        } catch {
        }
    }

    
    func addArea(newArea: Area) -> Int64? {
        do {
            let id = try db!.run(tblArea.insert(self.id <- newArea.id!,name <- newArea.name))
            return id
        } catch {
            return nil
        }
    }
    
    func addCity(_ newCity: City) -> Int64?{
        do {
            let id = try db!.run(tblCity.insert(self.id <- newCity.id!,name <- newCity.name,areaID <- newCity.areaID))
            return id
        } catch {
            return nil
        }
    }
    
    func addLine(newLine: Line) -> Int64? {
        do {
            let id = try db!.run(tblLine.insert(self.id <- newLine.id,name <- newLine.name,listStation <- newLine.listStation,company <- newLine.company,areaID <- newLine.areaID))
            return id
        } catch {
            return nil
        }
    }
    
    func addStation(newStaion: Station) -> Int64? {
        do {
            let id = try db!.run(tblStation.insert(self.id <- newStaion.id,name <- newStaion.name))
            return id
        } catch {
            return nil
        }
    }
    
    func querryLine() -> [Line]{
        var lines = [Line]()
        do {
            for line in try db!.prepare(self.tblLine) {
                let newLine = Line()
                newLine.id = String(line[id])
                newLine.name = line[name]!
                newLine.listStation = line[listStation]!
                newLine.areaID = line[areaID]!
                newLine.company = line[company]!
                lines.append(newLine)
            }
        } catch {
        }
        return lines
    }
    
//    func updateLine(newLine: Line) -> Bool {
//        let line = tblLine.filter(id == newLine.id)
//        do {
//            let update = line.update([
//                listStation <- newLine.listStation,
//                ])
//            if try db!.run(update) > 0 {
//                return true
//            }
//        } catch {
//            print("Update failed: \(error)")
//        }
//        return false
//    }
    
//    func deleteLine(_ deleteLine:Line) -> Bool {
//        do {
//            let line = tblLine.filter(id == deleteLine.id)
//            try db!.run(line.delete())
//            return true
//        } catch {
//            print("Delete failed")
//        }
//        return false
//    }
    
//    func deleteStation(_ deleteID:String) -> Bool {
//        do {
//            let station = tblStation.filter(id == deleteID)
//            try db!.run(station.delete())
//            print("Delete successfully")
//            return true
//        } catch {
//            print("Delete failed")
//        }
//        return false
//    }
    
    
    func queryLineByName(mName:String,mAreaID:String) -> [Line] {
        var lines = [Line]()
        let tbLine = tblLine.filter(areaID == mAreaID && name == mName)
        do {
            for mLine in try db!.prepare(tbLine) {
                let line = Line()
                line.id = String(mLine[id])
                line.name = mLine[name]!
                line.listStation = mLine[listStation]!
                line.areaID = mLine[areaID]!
                line.company = mLine[company]!
                let fullList = line.listStation.components(separatedBy: "_")
                for i in 1 ..< fullList.count{
                    line.stations.append(self.querryStationByName(mName: fullList[i], mAreaID: mAreaID))
                }
                lines.append(line)
            }
        } catch {
        }
        return lines
    }
    
    func queryAllArea() -> [Area] {
        var areas = [Area]()
        do {
            for area in try db!.prepare(self.tblArea) {
                let newArea = Area()
                newArea.id = String(area[id])
                newArea.name = area[name]
                newArea.cities = queryAllCity(String(area[id]))
                areas.append(newArea)
            }
        } catch {
        }
        return areas
    }
    
    func querryStationByName(mName:String,mAreaID:String) -> Station{
        var station = Station()
        let tbCity = tblStation.filter(areaID == mAreaID && name == mName)
        do {
            for mStation in try db!.prepare(tbCity) {
                station = Station(String(mStation[id]),
                                   mStation[name]!)
                return station
            }
        } catch {
        }
        return station
    }
    
    
    func querryAllStation() -> [Station] {
        var stations = [Station]()
        do {
            for station in try db!.prepare(self.tblStation) {
                let newStation = Station()
                newStation.id = String(station[id])
                newStation.name = station[name]!
                stations.append(newStation)
            }
        } catch {
            }
        return stations
    }
    
    
    func queryAllCity(_ mAreaID:String) -> [City] {
        var cities = [City]()
        if mAreaID=="" {
            do {
                for city in try db!.prepare(self.tblCity) {
                    let newCity = City(String(city[id]),
                                       city[name]!)
                    cities.append(newCity)
                }
            } catch {
            }
            return cities
        }else{
            let tbCity = tblCity.filter(areaID == mAreaID)
            do {
                for city in try db!.prepare(tbCity) {
                    let newCity = City(String(city[id]),
                                       city[name]!)
                    cities.append(newCity)
                }
            } catch {
            }
            return cities
        }
        
    }

    
    
}
