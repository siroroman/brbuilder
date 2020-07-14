//
//  Endpoints.swift
//  Bitrise_builder
//
//  Created by Roman Siro on 11/07/2020.
//  Copyright © 2020 Roman Siro. All rights reserved.
//

import Foundation

enum Endpoint {
    
    private var baseURL: String {"https://api.bitrise.io/v0.1"}
    
    case user
    case apps
    case workflows(slug: String)
    case build(slug: String)
    
    var url: URL {
        switch self {
        case .user: return URL(string: "\(baseURL)/me")!
        case .apps: return URL(string: "\(baseURL)/apps")!
        case .workflows(let slug): return URL(string: "\(baseURL)/apps/\(slug)/build-workflows")!
        case .build(let slug): return URL(string: "\(baseURL)/apps/\(slug)/builds")!
        }
    }
    
}
