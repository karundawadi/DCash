//
//  ContentView.swift
//  dCash
//
//  Created by Karun Dawadi on 5/23/21.
//

import SwiftUI
import Firebase

func application(_ application: UIApplication, didFinishLaunchingWithOptions
                    launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // [START firebase_configure]
    // Use Firebase library to configure APIs
    FirebaseApp.configure()
    // [END firebase_configure]
    return true
}

// For toast UI
struct Toast<Presenting>: View where Presenting: View {
    
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let heading: Text
    let content: Text
    
    var body: some View {
        if self.isShowing {DispatchQueue.main.asyncAfter(deadline: .now() + 3) {                 self.isShowing = false
        }
        }
        return GeometryReader { geometry in
            
            ZStack(alignment: .top) {
                
                self.presenting()
                    .blur(radius: self.isShowing ? 1 : 0)
                
                VStack {
                    self.heading
                    self.content
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height / 5)
                .background(Color.black)
                .foregroundColor(Color.white)
                .cornerRadius(2)
                .transition(.slide)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            self.isShowing = false
                        }
                    }
                }
                .opacity(self.isShowing ? 1 : 0)
            }
            
        }
        
    }
    
}
// Extension for ToastUI
extension View {
    
    func toast(isShowing: Binding<Bool>, heading: Text, content: Text) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              heading: heading,
              content:content)
    }
    
}

struct ContentView: View {
    @State var displayView = true
    var body: some View {
        if displayView == true{
            signin(displayView: $displayView)
        }else{
            TabView{
                addExpense()
                    .tabItem{
                        Label("Add Expense", systemImage: "plus.circle")
                    }
                totalExpense()
                    .tabItem{
                        Label("This month", systemImage: "chart.pie")
                    }
                reminders().tabItem{
                    Label("Reminders", systemImage: "list.bullet.rectangle")
                }
                
                profile()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iphone se")
    }
}
