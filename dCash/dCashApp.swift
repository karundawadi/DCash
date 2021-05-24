//
//  dCashApp.swift
//  dCash
//
//  Created by Karun Dawadi on 5/23/21.
//

import SwiftUI
import Firebase

@main
struct dCashApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
