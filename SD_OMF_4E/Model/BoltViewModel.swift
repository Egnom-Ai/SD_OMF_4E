//
//  BoltViewModel.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import Foundation

class BoltViewModel: ObservableObject {
    @Published var selectedGroup: Bolt.Group = .a_n
}
