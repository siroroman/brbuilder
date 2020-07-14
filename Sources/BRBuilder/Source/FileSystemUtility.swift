//
//  Utility.swift
//  Bitrise_builder
//
//  Created by Roman Siro on 13/07/2020.
//  Copyright © 2020 Roman Siro. All rights reserved.
//

import Foundation
import AppKit


struct FileSystemUtility {
    
    func setProjectFolder() {
        if let url = promptForWorkingDirectoryPermission() {
            saveBookmarkData(for: url)
        }
    }
    func projectFolder() -> URL?  {
        guard let url = restoreFileAccess() else {
            if let url = promptForWorkingDirectoryPermission() {
                saveBookmarkData(for: url)
                return url
            }
            return nil
        }
        
        return url
    }
    
    private func promptForWorkingDirectoryPermission() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.message = "Choose project directory"
        openPanel.prompt = "Choose"
        openPanel.allowedFileTypes = ["none"]
        openPanel.allowsOtherFileTypes = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true

        openPanel.runModal()
        print(openPanel.urls) // this contains the chosen folder
        return openPanel.urls.first
    }
    
    private func saveBookmarkData(for workDir: URL) {
        do {
            let bookmarkData = try workDir.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            
            UserDefaults.standard.set(bookmarkData, forKey: Constants.projectFolderBookmarkKey)
            print("\(workDir) bookmark saved")

        } catch {
            print("Failed to save bookmark for \(workDir)", error)
        }
    }
    
    private func restoreFileAccess() -> URL? {
        if let bookmarkData = UserDefaults.standard.object(forKey: Constants.projectFolderBookmarkKey) as? Data {
            do {
                var isStale = false
                let url = try URL(resolvingBookmarkData: bookmarkData,
                                  options: .withoutUI,
                                  relativeTo: nil,
                                  bookmarkDataIsStale: &isStale)
                _ = url.startAccessingSecurityScopedResource()
                print("Bookmark access \(url) is restored.")
                return url
            } catch let error as NSError {
                print("Bookmark access failed: \(error.description)")
                return nil
            }
        }
        return nil
    }
}
