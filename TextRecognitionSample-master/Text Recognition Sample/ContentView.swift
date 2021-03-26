

import SwiftUI
import Foundation

struct ContentView: View {
    
    @State private var recognizedText = ""
    //@State var showarr : [Array<Any>]
    //@State var arr = savearr()//["林育生", "H123456789", "84/10/11"]
    @State var sendarr = [String]()
    @State private var test: Array<Any> = []
    @State private var recognizedTextID = ""
    @State private var recognizedTextName = ""
    @State private var Birday = Date()
    //@State private var savearr = [String]()
    @State private var showingScanningView = false
    @State private var SendScanning = false
    @State var eFlag = false
    @State private var showAlert = false
    
    //var savearray = ""
    //lazy var savearray = self.recognizedText.components(separatedBy: " ")
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    //          ZStack{
                    //                    RoundedRectangle(cornerRadius: 20, style:.continuous)
                    //                        .fill(Color.gray.opacity(0.2))
                    //              }
                    
                    //ForEach(arr.indices){ (index) in
                    //Text(arr[1] as! LocalizedStringKey)
                    //}
                    TextField("Tap button to start scanning", text: $recognizedText)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                    
                    TextField("姓名", text: $recognizedTextName)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        //.background(Color.gray.opacity(0.2))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.1), lineWidth: 5))
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {}
                        .onLongPressGesture(pressing: { isPressed in if isPressed { self.endEditing() } },perform: {})
                    TextField("身分證字號", text: $recognizedTextID)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .modifier(Validation(value: recognizedTextID)
                            { recognizedTextID in self.eFlag = checksend(source: recognizedTextID)//isValidID(recognizedTextID)
                            return self.eFlag
                            })
                        // .prefixedWithIcon(named: "envelope.circle.fill")
                        //.background(Color.gray.opacity(0.2))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.1), lineWidth: 5))
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {}
                        .onLongPressGesture(pressing: { isPressed in if isPressed { self.endEditing() } },perform: {})
                    DatePicker("出生年月日",selection: $Birday, in: ...Date(),  displayedComponents: .date)
                        .environment(\.locale, Locale.init(identifier: "zh-tw"))
                        .padding()
                    Button(action: {
                        self.showingScanningView = true
        //                        test = savearr2()
        //                        test = arr
        //                        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
        //                        print(test)
        //                        print(arr)
        //                        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                        })
                        {Text("掃描")}
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.blue))
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.SendScanning = true
                        showAlert = true
                    }) {
                        Text("送出")
                    }
                    .padding()
                    
                    .foregroundColor(.white)
                    .background(Capsule().fill(Color.blue))
                }
                .padding()
                .alert(isPresented: $showAlert) { () -> Alert in
                        let answer = ["送出"].randomElement()!
                        return Alert(title: Text(answer)
                                , message: Text("資料確認無誤")
                                , primaryButton: .destructive(Text("返回"))
                                     , secondaryButton: .default(Text("確認"))
                                        {
                                            _ = checksend(source: recognizedTextID)
                                        }
                                )
                }
            }
            .navigationBarTitle("身份登入確認")
//            .sheet(isPresented: $showingScanningView) {
//                //ScanDocumentView(recognizedText1: self.$recognizedText);
//                //sendarr[0] = self.recognizedTextName
//                //sendarr[1] = self.recognizedTextID
//                //sendarr[2] = self.Birday
//
//                //savetext = ScanDocumentView(recognizedText1: self.$recognizedText)//, savearr: self.$showarr)//, recognizedTextID: self.$recognizedTextID)
//
//            }
            .sheet(
                isPresented: $showingScanningView, content: {
                ScanDocumentView(
                    recognizedText1: self.$recognizedText, recognizedTextID1: self.$recognizedTextID, recognizedTextName1: self.$recognizedTextName, Birday1: self.$Birday);
            })
            //public init()
            
//            let savetext = ScanDocumentView(recognizedText1: self.$recognizedText)
            //print("////////////////////////////////")
        }
    }
}

//func savearr () -> Array<Any> {
//    //var priarr = save.split// components(separatedBy: " ")
//    let arr = ["林育生", "H123456789", "84/10/11"]
//    return arr
//}




//鍵盤return
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

//鍵盤手勢
extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

