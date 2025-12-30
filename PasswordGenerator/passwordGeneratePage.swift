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
    
    @Binding var goToPage: String
    @Binding var buttonTapped: Bool

    var body: some View {
        Color.blue .ignoresSafeArea()
        Rectangle()
            .fill(Color.white)
            .edgesIgnoringSafeArea(.all)
            .frame(width: 360, height: 770)
            .cornerRadius(20)

        VStack {
            HStack {
                Button {
                    goToPage = "Home"
                    buttonTapped = false
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())
                }

                Spacer()
            }
            .padding()

            Spacer()

            Text("Password Generator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Spacer()
        }
    }
}

