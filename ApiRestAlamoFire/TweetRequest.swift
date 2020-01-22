//
//  TweetRequest.swift
//  ApiRestAlamoFire
//
//  Created by Nestor Blanco on 1/22/20.
//  Copyright © 2020 Nestor Blanco. All rights reserved.
//

import Foundation

/// Objeto que se obtendra del Request
struct TweetRequest: Codable {
    let tweetRequestId: Int?
    let deviceToken: String?
    let hashTag: String?
    
    private enum CodingKeys:String, CodingKey{
        case tweetRequestId = "id"
        case deviceToken = "device_token"
        case hashTag
        
    }
}
