//
//  BreatheType.swift
//  BreathApp
//
//  Created by Akhilgov Magomed Abdulmazhitovich on 28.07.2022.
//

import Foundation
import SwiftUI

struct BreatheType: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var color: Color
}

let sampleTypes: [BreatheType] = [
    .init(title: "Anger", color: .mint),
    .init(title: "Irritation", color: .brown),
    .init(title: "Sadness", color: Color("Purple"))
]
