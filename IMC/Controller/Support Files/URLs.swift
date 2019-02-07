//
//  URLs.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 1/31/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import Foundation
struct URLs{
    static public let ROOT_URL:String = "http://imc.sobelnaza.com/api/"
    static public let URL_CLINIC:String = ROOT_URL + "clinics"
    static public let URL_SPECIALIST:String =  ROOT_URL + "specialits"
    static public let URL_RESRVE:String = ROOT_URL + "reserve"
    static public let URL_RESRVE_EXPERT:String = ROOT_URL + "specialist/reserve"
    static public let URL_DOCTOR:String = ROOT_URL + "docts_times/"
}
