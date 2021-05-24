//
//  ContentView.swift
//  dCash
//
//  Created by Karun Dawadi on 5/23/21.
//

import SwiftUI
import Firebase


struct ContentView: View {
    @State var displayView = true
    var body: some View {
        if displayView == true{
            login_screen(displayView: $displayView)
        }else{
            TabView{
                TabView1()
                    .tabItem{
                        Text("1")
                    }
                TabView2()
                    .tabItem{
                        Text("2")
                    }
            }
        }
    }
}

struct login_screen : View{
    @Binding var displayView:Bool
    var body: some View{
        Text("This is the login screen!!!")
        Button("Sign In",action: {
            self.displayView = false
        })
    }
}

// For tab view 1
struct TabView1 : View {
    var body: some View{
        Text("First Tab View")
    }
}

// For tab view 2
struct TabView2 : View {
    var body: some View{
        Text("Second Tab View")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iphone se")
    }
}
