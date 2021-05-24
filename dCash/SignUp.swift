//
//  SignUp.swift
//  dCash
//
//  Created by Karun Dawadi on 5/23/21.
//

import SwiftUI

struct SignUp: View {
    @Binding var showView : Bool
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button(
            action:{
                self.showView = false
            },
            label:{
                Text("Back")
            }
        )
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(showView: .constant(false))
    }
}
