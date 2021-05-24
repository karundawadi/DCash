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
    @State var display_signup = false
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""
    
    var body: some View{
        if display_signup == true{
            sign_up_screen(displaySignUp: $display_signup)
        }else{
            NavigationView{
                VStack{
                    TextField("Email",text: $userEmail)
                        .padding(.horizontal,20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        
                    TextField("Password",text:$userPassword)
                        .padding(.horizontal,20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        
                        Button(action: {
                            self.displayView = false
                        }){
                            Text("Sign In")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(Color.white)
                                .cornerRadius(CGFloat(10),antialiased: true)
                                .padding(10)
                        }
                    
                }.toolbar(content: {
                    Button(action: {
                        self.display_signup = true
                    }){
                        Text("Sign Up")
                    }
                })
            }
        }
    }
}

struct sign_up_screen : View{
    @Binding var displaySignUp:Bool
    @State var user_email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView{
            VStack{
                HStack {
                    VStack {
                        HStack {
                            Text("Email")
                            Spacer()
                            TextField("Your Email",text:$user_email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 150)
                                .foregroundColor(.gray)
                                .accentColor(.red)
                        }
                        .padding(.horizontal, 20)
                        
                        HStack {
                            Text("Password")
                            Spacer()
                            TextField("Enter a password",text:$password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 150)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
                
                Button(action: {
                    self.displaySignUp = false
                }){
                    Text("Sign Up")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(CGFloat(10),antialiased: true)
                        .padding(10)
                }
            }.toolbar(content: {
                Button(action:{
                    self.displaySignUp = false
                    login_screen(displayView: $displaySignUp)
                }){
                    Text("Cancel")
                }
            })
        }
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
