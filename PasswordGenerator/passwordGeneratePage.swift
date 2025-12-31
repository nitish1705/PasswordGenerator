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
    
    @State private var passLength = 16
    @State private var useUpperCase = true
    @State private var useLowerCase = true
    @State private var useNumbers = true
    @State private var useSymbols = true
    
    @State private var generatedPassword = ""
    
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
                HStack(spacing: 130){
                    Button{
                        generatedPassword = ""
                    } label: {
                        Text("Clear")
                            .foregroundColor(Color(red: 1.0, green: 1.0, blue: 1.0))
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 170, height: 40)
                            )
                    }
                    Button{
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
                                print("Failed to generate password:", error)
                            }
                        }
                    } label: {
                        Text("Generate")
                            .foregroundColor(Color(red: 1.0, green: 1.0, blue: 1.0))
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 170, height: 40)
                            )
                    }
                    
                }
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


#Preview {
    passwordGeneratePage()
}

