//
//  passwordGeneratePage.swift
//  PasswordGenerator
//
//  Created by Nitish M on 29/12/25.
//

import Foundation
import SwiftData
import SwiftUI

struct PasswordResponse: Codable {
    let password: String
}


struct passwordGeneratePage: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var passLength = 16
    @State private var useUpperCase = true
    @State private var useLowerCase = true
    @State private var useNumbers = true
    @State private var useSymbols = true
    
    @State private var generatedPassword = ""
    
    @State private var storeClick = false
    
    @Query private var passwords: [passwordModel]
    
    func pass(
        length: Int,
        useUpperCase: Bool,
        UseLowerCase: Bool,
        useNumbers: Bool,
        useSymbols: Bool
    )async throws -> String{
        var URLString = "https://api.genratr.com/?length=\(length)"
        
        if useUpperCase {URLString += "&uppercase" }
        if UseLowerCase {URLString += "&lowercase" }
        if useSymbols {URLString += "&special"}
        if useNumbers {URLString += "&numbers" }
        
        guard let url = URL(string: URLString) else{
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(PasswordResponse.self, from: data)
        return decoded.password
    }
    
    
    var body: some View {
        ZStack{
            Color.orange.ignoresSafeArea()
            VStack(){
                Text("Generate Password")
                    .foregroundStyle(Color(.label))
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                
                HStack(){
                    passwordDisplayFrame(password: generatedPassword)
                    Button{
                        UIPasteboard.general.string = generatedPassword
                    } label: {
                        VStack{
                            Image(systemName: "document")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 30))
                            Text("COPY")
                                .foregroundStyle(Color.black)
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, 50)
                HStack(spacing: 16) {
                    
                    Button {
                        generatedPassword = ""
                    } label: {
                        Text("Clear")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }

                    Button {
                        storeClick = true
                    } label: {
                        Text("Store")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }

                    Button {
                        Task {
                            do {
                                generatedPassword = try await pass(
                                    length: passLength,
                                    useUpperCase: useUpperCase,
                                    UseLowerCase: useLowerCase,
                                    useNumbers: useNumbers,
                                    useSymbols: useSymbols
                                )
                            } catch {
                                print("Error generating password")
                            }
                        }
                    } label: {
                        Text("Generate")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                .padding(.bottom, 50)
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.5))
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("Password Settings")
                                .font(.title2)

                            Grid(alignment: .leading, horizontalSpacing: 40, verticalSpacing: 50) {
                                GridRow {
                                    Text("Length")
                                        .font(.title2)

                                    ZStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.gray.opacity(0.2))

                                        TextField("", value: $passLength, format: .number)
                                            .keyboardType(.numberPad)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 8)
                                    }
                                    .frame(width: 80, height: 36)
                                }
                                GridRow {
                                    Text("Include Uppercase")
                                    .font(.title2)

                                    Toggle("", isOn: $useUpperCase)
                                        .labelsHidden()
                                }
                                GridRow{
                                    Text("Include Lowecase")
                                        .font(.title2)
                                    
                                    Toggle("", isOn: $useLowerCase)
                                        .labelsHidden()
                                }
                                GridRow{
                                    Text("Include Numbers")
                                        .font(.title2)
                                    
                                    Toggle("", isOn: $useNumbers)
                                        .labelsHidden()
                                }
                                GridRow{
                                    Text("Include Symbols")
                                        .font(.title2)
                                    
                                    Toggle("", isOn: $useSymbols)
                                        .labelsHidden()
                                }
                            }
                            .padding()
                        }
                        .padding(.top, 10)
                    }
                }
                .frame(maxWidth: 370)
                .frame(height: 300)
                
                Button{
                    dismiss()
                } label: {
                    HStack{
                        Image(systemName: "chevron.left")
                        Text("Go back Home")
                    }
                    .foregroundStyle(Color(.systemBackground))
                    .frame(width: 200, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.blue.opacity(1))
                    )
                }
                .padding(.vertical, 50)
                Spacer()
                
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

struct passwordDisplayFrame: View {
    let password: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.6))

            ScrollView(.horizontal, showsIndicators: true) {
                Text(password)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .foregroundColor(.black)
            }
            .scrollIndicators(.hidden)
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}

struct storingPassword: View{
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelcontext
    @State var passsword: String
    @State var username: String
    
    var body: some View{
        NavigationStack{
            VStack(spacing: 40){
                FancyTextField(placeHolder: "Enter username", text: $username)
                FancyTextField(placeHolder: "Enter Password", text: $passsword)
                Button{
                    let newPassword = passwordModel(name: username, password: passsword)
                    modelcontext.insert(newPassword)
                    dismiss()
                } label: {
                    HStack{
                        Image(systemName: "plus")
                        Text("Store")
                    }
                    .foregroundStyle(Color(.white))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color.blue)
                            .frame(width: 100, height: 50)
                    )
                }
                Spacer()
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button{
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .principal){
                    Text("Store Passwords!!")
                        .font(.title3)
                }
            }
        }
    }
}
#Preview {
//    storingPassword(passsword: "", username: "")
}

