//
//  Doctor.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 2/2/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import Foundation
class Doctor {
    var doctorId: Int
    var name:String
    var degree:String
    var days : [String]
    var hours :[String]

    init(doctorId: Int,name:String,degree:String,days : [String],hours:[String]) {
       self.doctorId = doctorId
       self.name = name
        self.degree = degree
        self.days = days
        self.hours = hours
    }
}
