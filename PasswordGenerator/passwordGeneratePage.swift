//
//  passwordGeneratePage.swift
//  PasswordGenerator
//
//  Created by Nitish M on 29/12/25.
//

import Foundation
import SwiftData
import SwiftUI

struct passwordGeneratePage: View {
    @Environment(\.dismiss) private var dismiss
    
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
        
        return String(data: data, encoding: .utf8) ?? ""
    }
    @State private var generatedPassword = ""
    
    var body: some View {
        ZStack{
            Color.orange.opacity(1).ignoresSafeArea()
            VStack(spacing: 20){
                Text("Generate Password")
                    .font(.largeTitle)
                    .bold()
                    .offset(y: 45)
                
                HStack(){
                    passwordDisplayFrame(password: generatedPassword)
                    Button{
                        
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
                .offset(y: 30)
                HStack{
                    Button{
                        
                    } label: {
                        Text("Generate")
                            .foregroundColor(Color(red: 1.0, green: 1.0, blue: 1.0))
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 100, height: 40)
                            )
                    }
                    
                }
                Spacer()
                
                
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

struct passwordDisplayFrame: View{
    let password: String
    
    var body: some View{
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.6))
                )

            TextEditor(text: .constant(password))
                .padding(12)
                .scrollContentBackground(.hidden)
                .disabled(true)
                .foregroundColor(.black)
        }
        .frame(width: 300, height: 55)
        .frame(maxHeight: 200)
        .padding(.horizontal)
    }
}

#Preview {
    passwordGeneratePage()
}

