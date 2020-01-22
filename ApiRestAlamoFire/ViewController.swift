//
//  ViewController.swift
//  ApiRestAlamoFire
//
//  Created by Nestor Blanco on 1/22/20.
//  Copyright © 2020 Nestor Blanco. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //impleGetRequest()
        //parametherGetRequest()
        //httpHeadersRequest()
        //handlingAuthorization()
        //basicResponse()
        //jsonResponse()
        //dataResponse()
        //stringResponse()
        //decodableResponse()
        //downdloadLocally()
        //uploadDataFile()
        downloadProgress()

        
        }
    }

    /// simple GET request
    func simpleGetRequest() {
        /*
         Other Http Method:
         
         // POST
         AF.request("https://httpbin.org/post", method: .post)
         // PUT
         AF.request("https://httpbin.org/put", method: .put)
         // DELETE
         AF.request("https://httpbin.org/delete", method: .delete)
         
         */
        AF.request("https://httpbin.org/get", method: .get).response { response in
        debugPrint(response)
    }
        

}

    /// Request with Parameters
    func parametherGetRequest(){
        let url: String = "https://httpbin.org/get"
        let paramether = ["category":"Movies","genre":"Action"]
        
        AF.request(url,parameters: paramether).response{ response in
            debugPrint(response)
            
        }
        
    }

    /// HTTP Headers
    func httpHeadersRequest(){
        let url: String = "https://httpbin.org/get"
        let headers: HTTPHeaders = [.authorization(username:"test@email.com",password:"testpassword"),.accept("application/json")]
        
        AF.request(url,headers: headers).responseJSON{response in
            debugPrint(response)
        }
        
    }

    /// Handling Authorization
    func handlingAuthorization() {
        let url: String = "https://httpbin.org/basic-auth/"
        let user = "test@email.com"
        let password = "testpassword"
        // Normal way to authenticate using the .authenticate with username and password
        AF.request("https://httpbin.org/basic-auth/\(user)/\(password)").authenticate(username: user,password: password).responseJSON{ response in
            debugPrint(response)
        }
        
         // Authentication using URLCredential
        let credential = URLCredential(user: user, password: password, persistence: .forSession)

        AF.request("https://httpbin.org/basic-auth/\(user)/\(password)").authenticate(with: credential).responseJSON{ response in
            debugPrint(response)
        }
        
    }

    /// Basic Response
    func basicResponse(){
        let url: String = "https://httpbin.org/get"
        AF.request(url).response{ response in
            debugPrint(response)
            
        }
    }

    /// JSON Response
    func jsonResponse(){
        let url: String = "https://httpbin.org/get"
        AF.request(url).responseJSON{ response in
            debugPrint("Response: \(response)")
            
        }
    }

    /// Data Response
    func dataResponse(){
        let url: String = "https://httpbin.org/get"
        AF.request(url).responseData{response in
            debugPrint(response)
        }
    }

    /// String Response
    func stringResponse(){
        let url: String = "https://httpbin.org/get"
        AF.request(url).responseString{response in
            debugPrint(response)
        }
    }

    /// Decodable Response
    func decodableResponse(){
        struct HTTPBindResponse:Decodable {let url: String}
        let url: String = "https://httpbin.org/get"
        AF.request(url).responseDecodable(of: HTTPBindResponse.self){response in
            debugPrint("Response:\(response)")
        }
        
    }

    /// Fetch in Memory
    //func fetchInMemoryRequest(){
    //    let url: String = "https://httpbin.org/get"
    //    AF.download(url).responseData{ response in
    //        if let data = response.value {
    //            self.imageView.image = (data:data)
    //        }
    //
    //    }
    //}

    /// Download locally
    func downdloadLocally(){
        let url: String = "https://httpbin.org/image/png"
        let destination: DownloadRequest.Destination = {_, _ in
            let documentsURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
            let fileUrl = documentsURL.appendingPathComponent("image.png")
            return (fileUrl,[.removePreviousFile,.createIntermediateDirectories])
            
        }
        
        AF.download(url, to: destination).response{response in
            debugPrint(response)
            if response.error == nil, let imagePath = response.fileURL?.path{
                let image = UIImage(contentsOfFile: imagePath)
            }
        }
    }


    /// Uploading Data/Files
    func uploadDataFile(){
        let url: String = "https://httpbin.org/post"
        let data = Data("data".utf8)
        
        AF.upload(data, to: url).responseJSON{resonse in
            debugPrint(resonse)
        }
        
        //Multipart
        AF.upload(multipartFormData: {multipartForData in
            multipartForData.append(Data("one".utf8),withName: "one")
            multipartForData.append(Data("two".utf8),withName: "two")
        },to: url).responseJSON{ response in
            debugPrint(response)
        }
            
        //upload files
        let fileURL = Bundle.main.url(forResource: "video", withExtension: "mp4")!
         
        AF.upload(fileURL, to: "https://httpbin.org/post").responseJSON { response in
            debugPrint(response)
    }
}

    /// downloadProgress
    func downloadProgress() {
        let url: String = "https://httpbin.org/post"
        // For downloadProgress
         
             let destination: DownloadRequest.Destination = { _, _ in
                    let documentsURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
                        let fileURL = documentsURL.appendingPathComponent("image.png")
         
                     return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }
         
                AF.download(url, to: destination)
        .downloadProgress { progress in
               print("Download Progress: \(progress.fractionCompleted)")
             }
        .response { response in
                    debugPrint(response)
         
                    if response.error == nil, let imagePath = response.fileURL?.path {
                        let image = UIImage(contentsOfFile: imagePath)
                    }
                }
         
        // For uploadProgress
         
         let fileURL = Bundle.main.url(forResource: "video", withExtension: "mp4")!
         
                       AF.upload(fileURL, to: url)
                        .uploadProgress { progress in
                             print("Upload Progress: \(progress.fractionCompleted)")
                        }
                        .responseJSON { response in
                            debugPrint(response.response)
                       }
    }

