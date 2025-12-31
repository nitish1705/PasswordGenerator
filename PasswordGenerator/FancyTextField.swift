//
//  FancyTextField.swift
//  PasswordGenerator
//
//  Created by Nitish M on 01/01/26.
//

import Foundation
import SwiftUI

struct FancyTextField: View {
    let placeHolder: String
    @Binding var text: String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 350, height: 50)
                .foregroundStyle(Color(.gray.opacity(0.3)))
                .overlay{
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.gray), lineWidth: 1)
                }
            ZStack(alignment: .leading){
                if text.isEmpty {
                    Text(placeHolder)
                        .foregroundStyle(Color(.label).opacity(0.5))
                        .padding(.leading, 40)
                }
                
                TextField("", text: $text)
                    .padding(.leading, 40)
                    .foregroundStyle(Color(.label))
                
            }
        }
    }
}

#Preview {
    FancyTextField(
        placeHolder: "Enter something",
        text: .constant("")
    )
}
