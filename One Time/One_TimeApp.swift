//
//  One_TimeApp.swift
//  One Time
//
//  Created by Kilo Loco on 1/3/23.
//

import Amplify
import AWSCognitoAuthPlugin
import SwiftUI

@main
struct One_TimeApp: App {
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Successfully configured Amplify")
            
        } catch {
            print("Could not configure Amplify", error)
        }
    }
}
