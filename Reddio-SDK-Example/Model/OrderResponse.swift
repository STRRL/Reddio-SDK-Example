//
//  OrderResponse.swift
//  Reddio-SDK-Example
//
//  Created by STRRL on 2023/6/1.
//

import Foundation

struct OrderResponse: Hashable, Codable {
    var sequenceId: Int64
    enum CodingKeys: String, CodingKey {
        case sequenceId = "sequence_id"
    }
}
