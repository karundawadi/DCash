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
    @State var show_alert = false
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""
    @State var display_signup_alert = false
    @State var display_signup_alert_failed = false
    
    var body: some View{
        if display_signup == true{
            sign_up_screen(displaySignUp: $display_signup, display_signup_alert: $display_signup_alert, display_signup_alert_failed: $display_signup_alert_failed)
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
                        // Firebase authentication added
                        Auth.auth().signIn(withEmail: userEmail, password: userPassword){
                            (result,error) in
                            if let error = error {
                                print(error.localizedDescription)
                                self.show_alert = true
                            } else{
                                self.displayView = false
                            }
                        }
                    }){
                        Text("Sign In")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(Color.white)
                            .cornerRadius(CGFloat(10),antialiased: true)
                            .padding(10)
                    }.alert(isPresented: $show_alert){
                        Alert(title: Text("Sign in failed"),
                              message: Text("Either the password or user email is incorrect."),
                              dismissButton: .default(Text("Try Again!"))
                        )
                    }
                    
                }.toolbar(content: {
                    Button(action: {
                        self.display_signup = true
                    }){
                        Text("Sign Up")
                    }
                })
            }.alert(isPresented: $display_signup_alert){
                Alert(title: Text("Sign up completed"),
                      message: Text("You have successfully signed up. You can login to the system now."),
                      dismissButton: .default(Text("Continue"))
                )
            }
            .alert(isPresented: $display_signup_alert_failed){
                Alert(title: Text("Sign up unsuccessful"),
                      message: Text("We could not sign you please, please contact admin."),
                      dismissButton: .default(Text("Dismiss"))
                )
            }
        }
    }
}

struct sign_up_screen : View{
    @Binding var displaySignUp:Bool
    @Binding var display_signup_alert:Bool
    @Binding var display_signup_alert_failed:Bool
    @State var user_email = ""
    @State var password = ""
    @State var show_alert = false
    
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
                    Auth.auth().createUser(withEmail: user_email, password: password){
                        (result, error) in
                        if let error = error{
                            print(error.localizedDescription)
                            self.display_signup_alert_failed = true 
                        }else{
                            self.displaySignUp = false
                            self.display_signup_alert = true
                        }
                    }
                }){
                    Text("Sign Up")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(CGFloat(10),antialiased: true)
                        .padding(10)
                }.alert(isPresented: $show_alert){
                    Alert(title: Text("Sign in failed"),
                          message: Text("Either the password or user email is incorrect."),
                          dismissButton: .default(Text("Try Again!"))
                    )
                }
            }.toolbar(content: {
                Button(action:{
                    self.displaySignUp = false
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
