//
//  signin.swift
//  dCash
//
//  Created by Karun Dawadi on 5/25/21.
//

import SwiftUI
import Firebase

struct signin: View {
    @Binding var displayView:Bool
    @State var display_signup = false
    @State var display_signup_alert = false
    @State var show_alert = false
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""
    
    var body: some View{
        if display_signup == true{
            signup(displaySignUp: $display_signup)
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
                    }
                }.toolbar(content: {
                    Button(action: {
                        self.display_signup = true
                    }){
                        Text("Sign Up")
                    }
                })
                .toast(isShowing:$show_alert,heading:Text("Error:"),content:Text("Either the email or password is incorrect"))
                #warning("TODO: Implement a forgot password button")
            }
        }
    }
}

struct signin_Previews: PreviewProvider {
    static var previews: some View {
        signin(displayView: .constant(true))
    }
}
