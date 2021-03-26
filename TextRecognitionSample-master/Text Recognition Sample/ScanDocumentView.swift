//
//  ScanDocumentView.swift
//  Text Recognition Sample
//
//  Created by Stefan Blos on 25.05.20.
//  Copyright © 2020 Stefan Blos. All rights reserved.
//


import SwiftUI
import VisionKit
import Vision
import Foundation
import UIKit
import AVFoundation
import Foundation.NSString

//var entireRecognizedText = ""
var arr = [" ", " ", " "]
var allarr = [String]()
var i = 0

struct ScanDocumentView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var recognizedText1: String
    @Binding var recognizedTextID1: String
    @Binding var recognizedTextName1: String
    @Binding var Birday1: Date
    //@Binding var savearr : [Array<Any>]
    
    //@Binding var recognizedTextID = "A123456789"
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedText: $recognizedText1, recognizedTextID: $recognizedTextID1, recognizedTextName: $recognizedTextName1, Birday: self.$Birday1, parent: self)//,Savearr:savearr)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        // nothing to do here
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var recognizedText: Binding<String>
        var recognizedTextID: Binding<String>
        var recognizedTextName: Binding<String>
        var Birday: Binding<Date>
        var parent: ScanDocumentView
        //var savearr:[Array<Any>]
        
        init(recognizedText: Binding<String>, recognizedTextID: Binding<String>, recognizedTextName: Binding<String>, Birday: Binding<Date>, parent: ScanDocumentView){//, savearr:[Array<Any]) {
            self.recognizedText = recognizedText
            self.recognizedTextID = recognizedTextID
            self.recognizedTextName = recognizedTextName
            self.Birday = Birday
            self.parent = parent
            //self.savearr =
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let extractedImages = extractImages(from: scan)
            let processedText = recognizeText(from: extractedImages)
            recognizedText.wrappedValue = processedText[2]
            recognizedTextID.wrappedValue = processedText[1]
            recognizedTextName.wrappedValue = processedText[0]
            let dateFormatter = DateFormatter()
            if processedText[2].contains("/") {
                dateFormatter.dateFormat = "yyyy/MM/dd"
            }
            else{
                dateFormatter.dateFormat = "yyyy年MM月dd日"
            }
            //dateFormatter.dateFormat = "yyyy/MM/dd"
            let birDate = dateFormatter.date(from: processedText[2]) ?? Date()
            let addyear = 1911
            let calculatedDate = Calendar.current.date(byAdding: Calendar.Component.year, value: addyear, to: birDate)
            Birday.wrappedValue = calculatedDate!
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage] {
            var extractedImages = [CGImage]()
            for index in 0..<scan.pageCount {
                let extractedImage = scan.imageOfPage(at: index)
                guard let cgImage = extractedImage.cgImage else { continue }
                
                extractedImages.append(cgImage)
            }
            return extractedImages
        }
        
        fileprivate func recognizeText(from images: [CGImage]) -> [String] {
            var entireRecognizedText = "" //[String]()
            var allarr = [String]()
            
            let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
                guard error == nil else { return }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                let maximumRecognitionCandidates = 1
                //let strerror = "全民健康保險"
                for observation in observations {
                    guard let candidate = observation.topCandidates(maximumRecognitionCandidates).first else { continue }
                    //let boundingBox = observation.boundingBox
                    //entireRecognizedText += "\(candidate.string)\n"
                    
                    entireRecognizedText += "\(candidate.string)\n"
                    //print(entireRecognizedText)
                    
                    let word = candidate.string
                    let checkword = word.self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                    print(checkword)
                    allarr.append(checkword)
                    
                    
                    if self.validateFormat(str: checkword, type: 0) {//&& candidate.string != strerror {
                        //Name
                        //arr.append(candidate.string)
                        //arr[0] = checkword
                        let matchedname = self.matches(for: "(((?<=名)\\p{Han}*.*)|\\p{Han}+)", in: checkword)
                        print(matchedname)
                        arr[0] = matchedname
                    }
                        
                    else if self.validateFormat(str: checkword, type: 1) {
                        //ID
                        //arr.append(candidate.string)
                        //arr[1] = checkword
                        //arr[1] = validateFormat(str: , type: <#T##Int#>)
                        let matchedid = self.matches(for: "[A-Z]{1}[1-2]{1}[0-9]{8}$", in: checkword)
                        print(matchedid)
                        arr[1] = matchedid
                    }
                    
                    else if self.validateFormat(str: checkword, type: 2) {
                        //Bir
                        //arr.append(candidate.string)
                        //let checkbir = checkword.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789/年月日").inverted)
                        //print(checkbir)
                        let matchedbir = self.matches(for: "(((?<=民國).*\\p{Han}$)|(\\d{1,3}(\\-|\\/|\\.)\\d{1,2}(\\-|\\/|\\.)\\d{1,2}))", in: checkword)
                        arr[2] = matchedbir
                        //arr[2] = checkbir
                    }
                    
                    
                    print(arr)
                
                }
            }
            recognizeTextRequest.recognitionLevel = .accurate
            recognizeTextRequest.recognitionLanguages = ["zh-TW", "en-US"]
            recognizeTextRequest.usesLanguageCorrection = true
            //recognizeTextRequest.minimumTextHeight = 0.5
            
            for image in images {
                let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
                
                try? requestHandler.perform([recognizeTextRequest])
            }
//            print(entireRecognizedText)
//            arr = entireRecognizedText.components(separatedBy: "\n")
//            arr.removeLast()
//            print(arr.sorted(by: <))
//            arr.remove(at: 0)
            //arr.removeFirst()
            let Arr2string = arr.joined(separator: " ")
            entireRecognizedText = Arr2string
            
            let Allstring = allarr.joined(separator: "")
            print(Allstring)
            if arr[0] != nil{
                let matchedname = self.matches(for: "(((?<=名).*(?=出))|(?<=CE).*(?=[A-Z]))", in: Allstring)
                print(matchedname)
                arr[0] = matchedname
            }
            else if arr[2] != nil{
                let matchedname = self.matches(for: "((?<=國)\\d{1,3}\\p{Han}\\d{1,2}\\p{Han}\\d{1,2}(\\p{Han}?)(?=性)|(?<=\\d{9}).*(?=\\d{12}))", in: Allstring)
                print(matchedname)
                arr[2] = matchedname
            }
            
            return arr
            //return entireRecognizedText
        }
        
        func matches(for regex: String, in text: String) -> String {

            do {
                let regex = try NSRegularExpression(pattern: regex)
                let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
                let regarr = results.map {String(text[Range($0.range, in: text)!])}
                let regstr = regarr.joined(separator: "")
                return regstr
            } catch let error {
                print("invalid regex: \(error.localizedDescription)")
                return ""
            }
        }
        
        
        func validateFormat(str: String, type: Int) -> Bool {
            let regex: String
            switch type {
            case 0:
                // NAME
                regex = "(((?<=名)\\p{Han}+)|\\p{Han}*)"
                //print("0")
            case 1:
                // ID
                regex = "([A-Z]{1}[1-2]{1}[0-9]{8}$|^\\p{Han}+.*\\d$)"
                //print("1")
            default:
                // bir
                regex = "(((?<=民國).*\\p{Han}$)|(\\d{1,3}(\\-|\\/|\\.)\\d{1,2}(\\-|\\/|\\.)\\d{1,2})|(\\p{Han}+.*))"
                //print("2")
            }
            let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES[c] %@", regex)
            return predicate.evaluate(with: str)
        }
    }
}
func savearr2 () -> [String] {
    
    //let text = Coordinator: recon
    //var savearray = text.components(separatedBy: " ")
    //let arr = ["林育生", "H123456789", "84/10/11"]
    
    print (arr)
    
    return arr
}


