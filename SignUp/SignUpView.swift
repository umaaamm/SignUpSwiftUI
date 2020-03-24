//
//  ContentView.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

import SwiftUI


struct SignUpView: View {
   
    @ObservedObject private var viewModel : SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack{
            ColorCodes.primary.color().edgesIgnoringSafeArea(.all)
            
            
            VStack{
                Text("Umam Sign Up").font(.custom("Noteworthy-Bold", size: 40)).foregroundColor(Color.white)
                    .padding(.bottom,20.0)
                
                AuthTextField(Title: "Username", TextValue: $viewModel.username, errorValue: viewModel.usernameErr)
                AuthTextField(Title: "Email", TextValue: $viewModel.email, errorValue: viewModel.emailErr, keyboardType: .emailAddress)
                AuthTextField(Title: "Password", TextValue: $viewModel.password, errorValue: viewModel.passwordErr, isSecured: true)
                AuthTextField(Title: "Confirm Password", TextValue: $viewModel.confirmPassword, errorValue: viewModel.confirmPasswordErr, isSecured: true)
                Button(action: viewModel.signUp){
                    Text("Sign Up")
                }.frame(minWidth: 0, maxWidth: .infinity)
                    .disabled(!viewModel.enableSignUp)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(viewModel.enableSignUp ?
                        Color.black : Color.gray)
                    .cornerRadius(.infinity)
                    .padding(.top, 30)
                Text(viewModel.statusViewModel.title).font(.headline).fontWeight(.light).foregroundColor(viewModel.statusViewModel.color.color()).padding(.top)
                
            }.padding(60.0)
        }
    }
}


func SignUp(){
    print("cliked button")
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SignUpViewModel(authApi: AuthService.shared, authServiceParser: AuthServiceParser.shared)
        return SignUpView(viewModel: viewModel)
    }
}

struct AuthTextField : View {
    var Title : String = ""
    @Binding var TextValue : String
    var errorValue : String
    var isSecured : Bool = false
    var keyboardType : UIKeyboardType = .default
    var body: some View{
        VStack{
            if isSecured{
                SecureField(Title, text: $TextValue).padding().background(ColorCodes.bacgroundTextfield.color())
                    .cornerRadius(10).keyboardType(keyboardType)
            }else{
                TextField(Title, text: $TextValue).padding().background(ColorCodes.bacgroundTextfield.color())
                    .cornerRadius(10).keyboardType(keyboardType)
            }
            Text(errorValue).fontWeight(.light).foregroundColor(ColorCodes.failure.color()).frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        }
    }
    
}

extension ColorCodes{
    func color() -> Color {
        switch self {
        case .primary:
            return Color(red: 79/255, green: 139/255, blue: 43/255)
        case .failure:
            return Color(red: 219/255, green: 12/255, blue: 12/255)
        case .success:
            return Color(red: 0, green: 0, blue: 0)
        case .bacgroundTextfield:
            return Color(red: 239/255, green: 243/255, blue: 244/255)
        }
    }
}
