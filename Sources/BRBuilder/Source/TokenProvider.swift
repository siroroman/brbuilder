//
//  TokenLoader.swift
//  Bitrise_builder
//
//  Created by Roman Siro on 11/07/2020.
//  Copyright © 2020 Roman Siro. All rights reserved.
//

import Foundation

struct TokenProvider {
    
    private let console: ConsoleIO
    
    init(console: ConsoleIO, userDefaults: UserDefaults = .standard) {
        self.console = console
    }
    
    func save(token: String) {
        console.writeMessage("Saving token...")
        let key = Constants.tokenKey
        let data = Data(token.utf8)
        
        let result = KeyChain.save(key: key , data: data)
        
        switch result {
        case noErr: console.writeMessage("The token was saved")
        default: console.writeMessage("An error occurred while saving the token", to: .error)
        }
    }
    
    func load() -> String? {
        console.writeMessage("Loading token...")
        let key = Constants.tokenKey
        guard let data = KeyChain.load(key: key) else {return nil}
        
        console.writeMessage("Token loaded.")
        return data.toString()
    }
    
}
