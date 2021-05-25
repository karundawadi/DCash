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
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    
                    SecureField("Password",text:$userPassword)
                        .padding(.horizontal,20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    
                    
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
                        ) // Only this alert to prevent the user from seeing what is wrong
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
    @State private var isEmailValid = false
    @State private var isPasswordValid = false
    
    // Functions to verify various data defined here
    
    // This is to verify email
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    // This is to verify password
    func passwordValidator(_ string: String) -> Bool {
        if string.count < 6 {
            return false
        }
        return true
    }
    
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
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        }
                        .padding(.horizontal, 20)
                        
                        HStack {
                            Text("Password")
                            Spacer()
                            SecureField("Enter a password",text:$password)
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
                    if self.passwordValidator(self.password) && self.textFieldValidatorEmail(self.user_email){
                        Auth.auth().createUser(withEmail: user_email, password: password){
                            (result, error) in
                            if let error = error{
                                print(error.localizedDescription)
                                self.display_signup_alert_failed = true
                            }else{
                                self.display_signup_alert = true
                            }
                        }
                    }else{
                        self.isPasswordValid = false // If arrived to this point defianltely means password is incorrect
                    }
                    
                }){
                    Text("Sign Up")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(CGFloat(10),antialiased: true)
                        .padding(10)
                }
            }
            .alert(isPresented: $show_alert){
                Alert(title: Text("Sign in failed"),
                      message: Text("Either the password or user email is incorrect."),
                      dismissButton: .default(Text("Try Again!"))
                )
            }
            .alert(isPresented: $isEmailValid){
                Alert(title: Text("Err!"),
                      message: Text("Email is not correct."),
                      dismissButton: .default(Text("Try Again!"))
                )
            }
            .alert(isPresented: $isPasswordValid){
                Alert(title: Text("Err!"),
                      message: Text("Password must be greater than 6 characters."),
                      dismissButton: .default(Text("Try Again!"))
                )
            }
            .toolbar(content: {
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
