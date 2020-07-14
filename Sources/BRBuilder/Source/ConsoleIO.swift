//
//  ConsoleIO.swift
//  Bitrise_builder
//
//  Created by Roman Siro on 11/07/2020.
//  Copyright © 2020 Roman Siro. All rights reserved.
//

import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleIO {
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\(message)")
        case .error:
            fputs("\(message)\n", stderr)
        }
    }
    
    func printUsage() {
        writeMessage("usage: \(Constants.appName) < command >")
        writeMessage("\n\n List of commands:")
        writeMessage("\n\(Command.token.rawValue) < token > saves bitrise token to key chain")
        writeMessage("\n\(Command.user.rawValue) returns bitrise account details")
        writeMessage("\n\(Command.apps.rawValue) returns list of apps for acount")
        writeMessage("\n\(Command.slug.rawValue) return selected app slug, \(Command.slug.rawValue) < slug > saves selected app slug. Use command apps to obtain app slug.")
        writeMessage("\n\(Command.workflows.rawValue) < slug > returns list of workflows for given app. Use command apps to obtain app slug.")
        writeMessage("\n\(Command.build.rawValue) < workflowID > < branch > starts workflow on given branch. -t modifier adds tag to latest commit on given branch")
    }
    
    func printIncorrectArgc() {
        writeMessage("Incorrect number of arguments.", to: .standard)
    }
    
}


