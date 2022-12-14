//
//  InputView.swift
//  SpeechMe
//
//  Created by Haruka Masamura on 10/15/22.
//

import SwiftUI

//actual content stuff

struct InputView: View {
    @State var text = ""
    
    var body: some View {
            VStack {
                VStack(alignment: .leading) {
                    Image("speechme").resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50).padding(10)
                    Text("Enter the word you want to learn...")
                        .font(.custom("KumbhSans-SemiBold", fixedSize: 30).weight(.black))
                        .foregroundColor(Color.black.opacity(0.7))
                        .padding(10)
                    HStack {
                        TextField("", text: $text)
                            .placeholder(when: text.isEmpty) {
                                Text("type a word...").foregroundColor(Color.white)
                                    .opacity(0.5)
                                
                        }
                    }.modifier(customViewModifier(roundedCornes: 20, backgroundColor: Color(red: 0.0868, green: 0.1528, blue: 0.87), textColor: .white))
                }.padding(50)
                
                NavigationLink(destination: RecordView()) {
                    Text("Submit")
                    .frame(minWidth: 0, maxWidth: 60)
                    .padding(10)
                    .foregroundColor(Color(red: 0.0868, green: 0.1528, blue: 0.87))
                    .background(.white)
                    .font(.custom("KumbhSans-SemiBold", size: 16))
                    .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(red: 0.0868, green: 0.1528, blue: 0.87), lineWidth: 2)
                            )
            }
                .padding(-15)
          }
    
    }
}

struct customViewModifier: ViewModifier {
    var roundedCornes: CGFloat
    var backgroundColor: Color
    var textColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(40)
            .background(backgroundColor)
            .cornerRadius(roundedCornes)
            .padding(3)
            .foregroundColor(textColor)
            //.overlay(RoundedRectangle(cornerRadius: roundedCornes)
                        //.stroke( backgroundColor, lineWidth: 2.5))
            .font(.custom("KumbhSans-Regular", size: 30))

            .shadow(radius: 10)
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

class InputViewModel {
    var input: String?
}
