//
//  SplashView.swift
//  ChatApp
//
//  Created by Sugandhi Hansika Kalansooriya on 2023-06-03.


import SwiftUI



import SwiftUI

struct SplashView: View {
    @State private var isActive: Bool = false

    var body: some View {
        ZStack {
            Image("backgroundImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                if self.isActive {
                    MainMessagesView()
                } else {
                               
                
                    Text("MessageMe")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)

                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: self.isActive ? 75 : 0))
                        .padding(.bottom, 50)
                        .animation(.easeInOut(duration: 1.0))
                }
            }
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}
