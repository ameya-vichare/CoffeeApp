//
//  LoginView.swift
//  AuthModule
//
//  Created by Ameya on 03/12/25.
//

import SwiftUI
import DesignSystem
import AppUtils

public struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @StateObject private var kb = KeyboardObserver()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            AppColors.secondaryGray.ignoresSafeArea()
            
            VStack {
                Text("Welcome to BrewCrew!")
                    .font(AppFonts.mediumThirty)
                    .foregroundStyle(AppColors.black)
                    .padding([.top], AppPointSystem.point_100)
                
                Text("Login to your account")
                    .font(AppFonts.headlineRegular)
                    .foregroundStyle(AppColors.primaryGray)
                    .padding([.bottom], AppPointSystem.point_48)
                
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(AppFonts.headlineMedium)
                    
                    TextField("Username", text: $username, prompt: Text("for e.g john.doe")
                        .foregroundColor(AppColors.primaryGray)
                        .font(AppFonts.subHeadline)
                    )
                        .textFieldStyle(.plain)
                        .padding([.horizontal], AppPointSystem.point_16)
                        .padding([.vertical], AppPointSystem.point_16)
                        .background(
                            RoundedRectangle(cornerRadius: AppPointSystem.point_8)
                                .foregroundStyle(AppColors.white)
                        )
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding([.bottom], AppPointSystem.point_8)
                }
                .padding([.bottom], AppPointSystem.point_12)
                
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(AppFonts.headlineMedium)
                    
                    SecureField("Password", text: $password, prompt: Text("for e.g 1234, seriously don't use this!")
                        .foregroundColor(AppColors.primaryGray)
                        .font(AppFonts.subHeadline)
                    )
                        .textFieldStyle(.plain)
                        .padding([.horizontal], AppPointSystem.point_16)
                        .padding([.vertical], AppPointSystem.point_16)
                        .background(
                            RoundedRectangle(cornerRadius: AppPointSystem.point_8)
                                .foregroundStyle(AppColors.white)
                        )
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Button {
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppPointSystem.point_12)
                            .frame(height: AppPointSystem.point_52)
                            .foregroundStyle(AppColors.primaryCoffee)
                        
                        Text(
                            "Login"
                        )
                        .font(AppFonts.mediumSixteen)
                            .foregroundStyle(AppColors.white)
                    }
                }
                .buttonStyle(.plain)
                .padding([.top], AppPointSystem.point_32)
                
                Spacer()
            }
            .padding([.horizontal], AppPointSystem.point_24)
            .padding(.bottom, kb.height)
            .animation(.easeOut, value: kb.height)
        }
        
    }
}

#Preview {
    LoginView()
}
