//
//  TypiCode.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 17/08/25.
//

import Foundation

struct TypiCode: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case id = "id"
        case title = "title"
        case body = "body"
    }
}
