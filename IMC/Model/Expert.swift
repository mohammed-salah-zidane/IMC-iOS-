//
//  Expert.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 2/1/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import Foundation
class Expert {
    var expertName = ""
    var expertId = 0
    var expertNationality = ""
    var from = ""
    var to = ""
    var generalSpeciality = ""
    var speciality = ""
    init(expertName : String,expertId :Int,expertNationality: String, from : String,to : String,generalSpeciality : String, speciality : String) {
        self.expertName = expertName
        self.expertId = expertId
        self.expertNationality = expertNationality
        self.from = from
        self.to = to
        self.generalSpeciality = generalSpeciality
        self.speciality = speciality
    }
    
    
}
