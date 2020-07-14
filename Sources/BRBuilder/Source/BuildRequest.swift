//
//  BuildRequest.swift
//  Bitrise_builder
//
//  Created by Roman Siro on 12/07/2020.
//  Copyright © 2020 Roman Siro. All rights reserved.
//

import Foundation

public struct BuildRequest: Codable {
    public let buildParams: BuildParams
    public let hookInfo: HookInfo

    enum CodingKeys: String, CodingKey {
        case buildParams = "build_params"
        case hookInfo = "hook_info"
    }

    public init(buildParams: BuildParams, hookInfo: HookInfo) {
        self.buildParams = buildParams
        self.hookInfo = hookInfo
    }
    
}

public struct BuildParams: Codable {
    public let branch, workflowID: String
   
    enum CodingKeys: String, CodingKey {
        case branch
        case workflowID = "workflow_id"
    }

    public init(branch: String, workflowID: String) {
        self.branch = branch
        self.workflowID = workflowID
    }
}


public struct HookInfo: Codable {
    public let type: String

    public init(type: String) {
        self.type = type
    }
}

