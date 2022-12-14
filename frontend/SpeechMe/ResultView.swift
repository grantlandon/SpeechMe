//
//  ResultView.swift
//  SpeechMe
//
//  Created by Haruka Masamura on 10/15/22.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ResultView: View {
    @State private var results = [Result]()
    var body: some View {
        
        // view code
       
            ZStack (alignment: .leading) {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color.white)
                    .frame(width: 300, height: 450).padding(50).padding(.bottom, 40)
                Text("Score").foregroundColor(Color.accentColor)
                    .font(.custom("KumbhSans-SemiBold", size: 30)).frame(maxWidth: .infinity, alignment: .center).padding(.bottom, 200)
                Text("97")
                    .foregroundColor(Color.accentColor)
                    .font(.custom("KumbhSans-SemiBold", size: 130)).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                Text("out of 100")
                    .foregroundColor(Color.black).opacity(0.7)
                    .font(.custom("KumbhSans-Regular", size: 20)).frame(maxWidth: .infinity, alignment: .center).padding(.top, 200)
                ZStack{
                    NavigationLink("Practice") {
                        InputView()
                    }
                    .font(Font.custom("KumbhSans-SemiBold", size: 20))
                    .padding()
                    .background(.gray)
                    .foregroundColor(Color(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(maxWidth: 200, maxHeight: 700).padding(120).padding(.top, 600)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.accentColor)
        
    }
    
//    func loadResult() async {
//        guard let url = URL(string: "https://www.randomnumberapi.com/api/v1.0/random?min=1&max=100&count=1") else {
//            print("Invalid URL")
//            return
//        }
//
//        // retrieve data (toss meta data)
//        do {
//            let(data, _) = try await URLSession.shared.data(from: url)
//
//            if let decodedResponse = try? JSONDecoder().decode(Array<Int>.self, from: data) {
//                let result = decodedResponse
//                print(result)
//            }
//        } catch {
//            print("Invalid Data")
//        }
//    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
