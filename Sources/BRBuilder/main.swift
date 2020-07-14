//
//  main.swift
//  Bitrise_builder
//
//  Created by Roman Siro on 11/07/2020.
//  Copyright © 2020 Roman Siro. All rights reserved.
//

import Foundation

let console = ConsoleIO()
let tokenProvider = TokenProvider(console: console)
let apiClient = APIClient(tokenProvider: tokenProvider)
let fileSystemUtility = FileSystemUtility()
let bitriseBuilder = BitriseBuilder(console: console, tokenProvider: tokenProvider,
                                    apiClient: apiClient, fileSystemUtility: fileSystemUtility)

print(CommandLine.arguments)

if CommandLine.argc < 2 {
    bitriseBuilder.interactiveMode()
} else {
    bitriseBuilder.staticMode()
}


