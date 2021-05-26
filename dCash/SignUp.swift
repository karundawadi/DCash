//
//  signup.swift
//  dCash
//
//  Created by Karun Dawadi on 5/25/21.
//

import SwiftUI
import Firebase

struct signup: View {
    @Binding var displaySignUp:Bool
    @State var user_email = ""
    @State var password = ""
    @State var show_alert_signup = false
    @State var signuperr = false
    @State var signupsuccessful = false
    
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
    var body: some View{
        NavigationView{
            VStack{
                TextField("Enter your email",text: $user_email)
                    .padding(.horizontal,20)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                SecureField("Enter your password",text:$password)
                    .padding(.horizontal,20)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                Button(action: {
                    if self.passwordValidator(self.password) && self.textFieldValidatorEmail(self.user_email){
                        print("Password and email is correct")
                        Auth.auth().createUser(withEmail: user_email, password: password){
                            (result,error) in
                            if let error = error{
                                print(error.localizedDescription)
                                self.signuperr = true
                            }else{
                                self.signupsuccessful = true
                                // _ replaces unused statement let timer
                                _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                                    self.displaySignUp = false
                                }
                            }
                        }
                    }
                    else{
                        print("Password and email is incorrect")
                        self.show_alert_signup = true
                    }
                }){
                    Text("Sign Up")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(CGFloat(10),antialiased:true)
                        .padding(10)
                }
            }.toolbar(content: {
                Button(action:{
                    self.displaySignUp = false
                }){
                    Text("Cancel")
                }
            })
            .toast(isShowing:$signuperr,heading:Text("Err!"),content: Text("Please check the details again. The password should be longer than 8 letters."))
            
            .toast(isShowing:$show_alert_signup,heading:Text("Error:"),content:Text("Cannot create an account. Contact your system admin."))
            .toast(isShowing:$signupsuccessful,heading:Text("Signed up sucessful"),content: Text("You can now sign in !"))
        }
    }

}

struct signup_Previews: PreviewProvider {
    static var previews: some View {
        signup(displaySignUp: .constant(false))
    }
}
