//
//  ContentView.swift
//  PasswordGenerator
//
//  Created by Nitish M on 29/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var openAppTitle = false
    @State private var slideTitle = false
    @State private var showButtons = Array(repeating: false, count: 4)
    @State private var goToPage = ""
    @State private var nextPage = false

    let buttons = ["Generate Password", "View Stored Passwords", "Settings", "About"]

    var body: some View {
        NavigationStack{
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {

                    HStack(spacing: 6) {
                        Text("Generator")
                            .foregroundStyle(Color(.label))
                            .font(.system(size: 34, weight: .bold))
                            .offset(y: openAppTitle ? -60 : 80)
                            .opacity(slideTitle ? 1 : 0)
                            .offset(x: slideTitle ? 170 : -120)

                    Text("Password")
                            .foregroundStyle(Color(.label))
                            .font(.system(size: 34, weight: .bold))
                            .offset(y: openAppTitle ? -60 : 80)
                            .opacity(slideTitle ? 1 : 0)
                            .offset(x: slideTitle ? -170 : 120)
                    }

                    Spacer().frame(height: 40)

                    VStack(spacing: 20) {
                        ForEach(buttons.indices, id: \.self) { index in
                            Button {
                                switch index {
                                case 0 : goToPage = "GeneratePassword"
                                case 1 : goToPage = "StoredPasswords"
                                case 2 : goToPage = "Settings"
                                case 3 : goToPage = "About"
                                default: break
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                    nextPage.toggle()
                                }
                            } label: {
                                Text(buttons[index])
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.white.opacity(0.15))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.2))
                                    )
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.25), radius: 8, y: 6)
                                    .offset(y: showButtons[index] ? 0 : 40)
                                    .opacity(showButtons[index] ? 1 : 0)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
            }
            .navigationDestination(isPresented: $nextPage){
                switch goToPage {
                case "GeneratePassword" : passwordGeneratePage()
                case "StoredPasswords" : storePasswordPage()
                case "Settings" : settingsPage()
                case "About" : aboutPage()
                default: EmptyView()
                }
            }
        }
        .onAppear {
            animateIntro()
        }
    }
    func animateIntro() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                openAppTitle = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation(.easeInOut(duration: 0.8)) {
                slideTitle = true
            }
        }

        for i in 0..<showButtons.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2 + Double(i) * 0.25) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showButtons[i] = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
