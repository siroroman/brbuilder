//
//  BitriseBuilder.swift
//  Bitrise_builder
//
//  Created by Roman Siro on 11/07/2020.
//  Copyright © 2020 Roman Siro. All rights reserved.
//

import Foundation

class BitriseBuilder {
    
    private let console: ConsoleIO
    private let tokenProvider: TokenProvider
    private let apiClient: APIClient
    private let userDefaults: UserDefaults
    private let fileSystemUtility: FileSystemUtility
    
    init(console: ConsoleIO, tokenProvider: TokenProvider,
         apiClient: APIClient, fileSystemUtility: FileSystemUtility,
         userDefaults: UserDefaults = .standard) {
        self.console = console
        self.tokenProvider = tokenProvider
        self.apiClient = apiClient
        self.fileSystemUtility = fileSystemUtility
        self.userDefaults = userDefaults
    }
    
    func staticMode()  {
        guard let command = Command(rawValue: CommandLine.arguments[1]) else {
            console.writeMessage("Unknow command.", to: .error)
            console.printUsage()
            return
        }
    
        switch command {
        case .token: tokenCommand()
        case .user: userCommand()
        case .apps: appsCommand()
        case .workflows: workflowCommand()
        case .slug: slugCommand()
        case .build: buildCommand()
        case .help: helpCommand()
            
        }
    }
    
    func interactiveMode()  {
        console.writeMessage("Interactive mode is not available yet. Please use static mode mode instead")
    }
    
    // MARK: - Token
    private func tokenCommand() {
        guard CommandLine.argc == 3 else {
            console.writeMessage("Incorrect command. Please use \(Constants.appName) \(Command.token.rawValue) <Bitrise token>", to: .error)
            return
        }
        
        tokenProvider.save(token: CommandLine.arguments[2])
    }
    
    // MARK: - User
    
    private func userCommand() {
        console.writeMessage("Obtaining user info...")
        apiClient.call(endPoint: .user){_, _, _ in}
    }
    
    // MARK: - Apps
    private func appsCommand() {
        console.writeMessage("Obtaining app list...")
        apiClient.call(endPoint: .apps){_, _, _ in}
    }
    
    private func slugCommand() {
        switch CommandLine.argc {
        case 2:
            if let slug = userDefaults.string(forKey: Constants.slugKey) {
                self.console.writeMessage("App with slug: \(slug) is selected.")
            } else {
                self.console.writeMessage("No app selected.")
            }
        case 3:
            let slug = CommandLine.arguments[2]
            console.writeMessage("Setting app with slug \(slug)...")
            userDefaults.set(slug, forKey: Constants.slugKey)
            self.console.writeMessage("App with slug: \(slug) is selected.")
        default: console.printIncorrectArgc()
        }
    }
    
    // MARK: - Workflows
    private func workflowCommand() {
        console.writeMessage("Obtaining workflow list...")
        guard let slug = userDefaults.string(forKey: Constants.slugKey) else {
            console.writeMessage("No app slug selected. Use \(Constants.appName) \(Command.slug.rawValue) < App slug> to set app slug.", to: .error)
            return
        }
        
        apiClient.call(endPoint: .workflows(slug: slug)){_, _, _  in}
    }
    
    // MARK: - Start workflow
    
    private func buildCommand() {
        guard CommandLine.argc > 3 else {
            console.printIncorrectArgc()
            return
        }
        
        guard let slug = userDefaults.string(forKey: Constants.slugKey) else {
            console.writeMessage("No app slug selected. Use \(Constants.appName) \(Command.slug.rawValue) < App slug> to set app slug.", to: .error)
            return
        }
        
        if CommandLine.argc == 5 && CommandLine.arguments[4] == "-t" {
            tagCommand()
        }
        
        let workflowID = CommandLine.arguments[2]
        let branch = CommandLine.arguments[3]
        
        console.writeMessage("Sending build request with workflow \(workflowID) on \(branch)...")
        
        let buildParams = BuildParams(branch: branch, workflowID: workflowID)
        let hookInfo = HookInfo(type: "bitrise")
        let buildRequest = BuildRequest(buildParams: buildParams, hookInfo: hookInfo)
        
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(buildRequest) else {
            console.writeMessage("Could not encode BuildRequest", to: .error)
            return
        }
        
        apiClient.call(endPoint: .build(slug: slug), method: .post, body: data) {_, _, _  in}
        
    }
    
    private func tagCommand() {
        let url = fileSystemUtility.projectFolder()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd-MM-yyyy_HH-mm-ss"
        let dateString = formatter.string(from: date)
        
        let workflowID = CommandLine.arguments[2]
        let branch = CommandLine.arguments[3]
        let tag = "\(workflowID)_\(dateString)"
        
        console.writeMessage("Setting tag \(tag)...")
        _ = runGitCommand(arguments: ["tag", tag, branch], directory: url)
        
        console.writeMessage("Searching remote repo...")
        let remote = runGitCommand(arguments: ["remote"], directory: url)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        console.writeMessage("Pushing tag \(tag) to \(remote)")
        _ = runGitCommand(arguments: ["push", remote, tag], directory: url)
    }
    
    private func runGitCommand(arguments: [String], directory: URL?) -> String? {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.currentDirectoryURL = directory
        task.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        task.arguments = arguments

        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        let output = String(data: data, encoding: .utf8)
        print(output ?? "")
        return output
    }
    
    // MARK: Help command
    private func  helpCommand() {
        console.printUsage()
    }
    
}
