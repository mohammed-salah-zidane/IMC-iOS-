//
//  API.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 1/31/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class API: NSObject {

    class func fetchClinic (completion:@escaping (_ error:Error?,_ success : Bool,_ clinics : [Clinic])->Void){
        var cName = ""
        var cID = 0
        var cFNum = 0
        var clinics = [Clinic]()
          Alamofire.request(URLs.URL_CLINIC, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    completion(error,false,[])
                    print(error)
                case .success( let value):
                    let json = JSON(value)
                    for i in json {
                        if let name = i.1["name"].string{ cName = name }
                        if let id = i.1["id"].int{ cID = id }
                        if let floorNum = i.1["flo_n"].int{ cFNum = floorNum }
                        let clinic = Clinic(clinicName: cName, clinicId: cID, floorNum: cFNum)
                        clinics.append(clinic)
                    }
                    completion(nil,true,clinics)
                }
        }
        
    }
    
    class func fetchExpert (completion:@escaping(_ error : Error? ,_ success : Bool, _ experts :[Expert] )->Void ){
        
        var experts = [Expert]()
        var name = ""
        var nationality = ""
        var id = 0
        var from = ""
        var to = ""
        var general = ""
        var speciality = ""
        Alamofire.request(URLs.URL_SPECIALIST, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                    case .failure(let error):
                        completion(error,false,[])
                           print(error)
                    case .success(let value):
                            // print(value)
                             let json = JSON(value)
                             for object in json{
                                
                                if let eName = object.1["name"].string { name = eName }
                                if let eNationality = object.1["nationality"].string
                                {nationality = eNationality}
                                if let eId = object.1["id"].int { id = eId }
                                if let eFrom = object.1["from"].string { from = eFrom }
                                if let eTo = object.1["to"].string { to = eTo }
                                if let eGeneral = object.1["public_sp"].string{ general = eGeneral}
                                if let eSpciality = object.1["accurate_sp"].string{ speciality = eSpciality }
                                let expert = Expert(expertName: name, expertId: id, expertNationality: nationality, from: from, to: to, generalSpeciality: general, speciality: speciality)
                                experts.append(expert)
                             }
                             completion(nil,true,experts)
                }
        }
        
    }

    class func fetchDoctors(id:Int , completion:@escaping ( _ error : Error? ,_ success : Bool ,_  doctors : [Doctor] )->Void) {
        
        var doctors = [Doctor]()
        
        var doctorId: Int = 0
        var name:String = ""
        var degree = ""
        
        var days = [String]()
        var hours = [String]()
        
        var tDoctorId = 0
        var day = ""
        var fromTo = ""
        
    
        Alamofire.request(URLs.URL_DOCTOR + String(id), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    completion(error,false,[])
                    print(error)
                case .success(let value):
                    //print(value)
                    let json = JSON(value)
                    // for object in json{}
                    let doctorJson = json["doctors"]
                    for doctor in doctorJson {
                        if let ID = doctor.1["id"].int { doctorId = ID }
                        if let Name = doctor.1["name"].string { name = Name}
                        if let Degree = doctor.1["scient_degree"].string { degree = Degree }
                        
                        let dateJson = json["times"]
                        days.removeAll()
                        hours.removeAll()

                        //loop for doctors dates
                        for time in dateJson {
                            
                            if let Day = time.1["day_name"].string { day = Day}
                            if let from_to = time.1["from_to"].string { fromTo = from_to }
                            if let tDocID = time.1["doctor_id"].string { tDoctorId = (tDocID as NSString ).integerValue}
                            if doctorId == tDoctorId {
                                days.append(day)
                                hours.append(fromTo)
                            }
            
                        }
                        //print(days.count)
                        
                       // print(hours.count)
                        let doctorObject = Doctor(doctorId: doctorId, name: name, degree: degree, days: days ,hours : hours)
                        doctors.append(doctorObject)
                       
                    }
                   
                    completion(nil,true,doctors)

           }
        }
    }
    
    
    class func doctorReserveDate(id : Int,name : String,phone:String,plain:String , completion: @escaping (_ error : Error? ,_ success : Bool)->Void){
     
        let url:String = URLs.URL_RESRVE + "/" + String(id) + "/" + name + "/" + phone + "/" + plain
        
       let Url = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(Url! , method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                switch response.result
                {
                case  .failure(let error):
                    print(error)
                    completion(error,false)
                    case .success(let value):
                      let json = JSON(value)
                       print(json)
                    completion(nil,true)
                }
        }
    }
    
    class func expertReserveDate(id : Int,name : String,phone:String,plain:String , completion: @escaping (_ error : Error? ,_ success : Bool)->Void){
        
        let url:String = URLs.URL_RESRVE_EXPERT + "/" + String(id) + "/" + name + "/" + phone + "/" + plain
        
        let Url = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(Url! , method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                switch response.result
                {
                case  .failure(let error):
                    print(error)
                    completion(error,false)
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    completion(nil,true)
                }
        }
    }
}
