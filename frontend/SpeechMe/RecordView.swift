//
//  RecordView.swift
//  SpeechMe
//
//  Created by Haruka Masamura on 10/15/22.
//

import SwiftUI
import AVKit

// creating audio recorder

struct Record : View {
    @State var record = false
    // creating instance for recroding...
    @State var session : AVAudioSession!
    @State var recorder : AVAudioRecorder!
    @State var alert = false
    // Fetch Audios...
    @State var audios : [URL] = []
    
    let viewModel = RecordViewModel()
    
    var body: some View{
        VStack{
            VStack{
                Image("speechme").resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40).padding(.trailing, 300.0)
//                Text("Word")
//                    .font(Font.custom("KumbhSans-Regular", size: 20))
                Text("Dog")
                    .font(Font.custom("KumbhSans-SemiBold", size: 50))
                    .foregroundColor(Color.accentColor)
                    .padding(80)
                    .background(.white)
                    .foregroundColor(Color(.gray))
                    .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.accentColor, lineWidth: 4.5)
                            )
                Button(action: {
                    do{
                        if self.record {
                            self.recorder.stop()
                            self.record.toggle()
                            // updating data for every rcd...
                            self.getAudios()
                            return
                        }
                        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileURL = url.appendingPathComponent("myRcd\(self.audios.count + 1).m4a")
                        viewModel.fileName = "myRcd\(self.audios.count + 1).m4a"
                        viewModel.fileURL = fileURL
                        let settings = [
                            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey : 12000,
                            AVNumberOfChannelsKey : 1,
                            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
                        ]
                        self.recorder = try AVAudioRecorder(url: fileURL, settings: settings)
                        self.recorder.record()
                        self.record.toggle()
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }) {
                    VStack {
                        ZStack{
                            VStack{
                                Text("Say your word")
                                    .font(.custom("KumbhSans-SemiBold", size: 30))
                                    .foregroundColor(Color.gray)
                            }.padding(.bottom, 120)
                    
                            Circle()
                                .fill(Color.red)
                                .frame(width: 70, height: 70).padding(.top, 90)
                            
                            if self.record{
                                
                                Circle()
                                    .stroke(Color.gray, lineWidth: 6)
                                    .frame(width: 85, height: 85).padding(.top, 90)
                            }
                        }
                        Text("Record")
                            .padding(.top)
                            .foregroundColor(Color.gray)
                    }
                }
                .padding(.vertical, 70)
                NavigationLink("Get Results") {
                    ResultView()
                }
                .onTapGesture {
                    guard let fileURL = viewModel.fileURL else {
                        return
                    }
                    guard let fileName = viewModel.fileName else {
                        return
                    }
                    uploadAudio(paramName: "audio", fileURL: fileURL, fileName: fileName)
                }
                .font(Font.custom("KumbhSans-SemiBold", size: 20))
                .padding()
                .background(Color("AccentColor"))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
        }
        .alert(isPresented: self.$alert, content: {
            Alert(title: Text("Error"), message: Text("Enable Access"))
        })
        .onAppear {
            do{
                self.session = AVAudioSession.sharedInstance()
                try self.session.setCategory(.playAndRecord)
                self.session.requestRecordPermission { (status) in
                    if !status{
                        self.alert.toggle()
                    }
                    else{
                        self.getAudios()
                    }
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func getAudios(){
        do{
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            self.audios.removeAll()
            
            for i in result{
                
                self.audios.append(i)
            }
        }
        catch{
            
            print(error.localizedDescription)
        }
    }
}

struct RecordView: View {
    var body: some View {
        Record()
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}

func uploadAudio(paramName: String, fileURL: URL, fileName: String) {
    let url = URL(string: "http://api-host-name/v1/api/uploadfile/single")

    // generate boundary string using a unique per-app string
    let boundary = UUID().uuidString

    let session = URLSession.shared

    // Set the URLRequest to POST and to the specified URL
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "POST"

    // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
    // And the boundary is also set here
    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    var data = Data()

    // Add the image data to the raw http request data
    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
    data.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
//    data.append(image.pngData()!)
    do {
        data.append(try Data(contentsOf: fileURL))
    } catch {
        print("file not found")
    }

    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

    // Send a POST request to the URL, with the data we created earlier
    session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
        if error == nil {
            let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
            if let json = jsonData as? [String: Any] {
                print(json)
            }
        }
    }).resume()
}

//func makePostReq(audio: String) {
//    guard let url = URL(string: "") else {
//        return
//    }
//
//    var request = URLRequest(url: url)
//    // method, body, headers
//    request.httpMethod = "POST"
//    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "")
//    let body: [String: AnyHashable] = [
//        "audio": audio,
//        "text": "Hello"
//    ]
//    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
//
//    // make the request
//    let task = URLSession.shared.dataTask(with: request) { data, _, error in
//        guard let data = data, error == nil else {
//            return
//        }
//
//        do {
//            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            print("SUCESS: \(response)")
//        } catch {
//            print(error)
//        }
//    }
//    task.resume()
//}

class RecordViewModel {
    var fileURL: URL?
    var fileName: String?
}
