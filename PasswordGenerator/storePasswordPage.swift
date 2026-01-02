//
//  storePasswordPage.swift
//  PasswordGenerator
//
//  Created by Nitish M on 29/12/25.
//

import Foundation
import SwiftUI
import SwiftData

struct storePasswordPage: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var currPasswword: passwordModel? = nil
    
    @Query var passwords : [passwordModel]
    var body: some View {
        ZStack{
            Color.orange.ignoresSafeArea()
            VStack{
                List{
                    ForEach(passwords, id: \.self) { password in
                        HStack{
                            VStack(alignment: .leading){
                                Text("Username: \(password.name)")
                                Text("Password: \(password.password)")
                                Spacer()
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .swipeActions(edge: .trailing) {
                            Button{
                                currPasswword = password
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                            Button(role: .destructive) {
                                modelContext.delete(password)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.5))
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
        }
//        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .principal){
                Text("Passwords are stored here!")
                    .foregroundStyle(Color(.label))
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarBackground(.clear, for: .navigationBar)
    }
}

#Preview {
    storePasswordPage()
}

