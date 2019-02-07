//
//  File.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 1/31/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import Foundation
 class Clinic {
    
    var clinicName:String
    var clinicId:Int
    var floorNum:Int
    
    init(clinicName :String,clinicId:Int,floorNum:Int) {
        self.clinicName = clinicName
        self.clinicId = clinicId
        self.floorNum = floorNum
    }
}
