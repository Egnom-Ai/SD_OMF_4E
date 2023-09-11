//
//  EndPlateViewModel.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import Foundation

class EndPlateViewModel: ObservableObject {
    @Published var selectedSpecification: ASTM.Specification = .a572
}
