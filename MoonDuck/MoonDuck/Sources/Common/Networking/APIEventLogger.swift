//
//  APIEventLogger.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation
import Alamofire

class APIEventLogger: EventMonitor {
    let queue = DispatchQueue(label: "MoonDuckAPILogger")
    
    func requestDidFinish(_ request: Request) {
        
        let headers = request.request?.allHTTPHeaderFields ?? [:]
        let urlStr = request.request?.url?.absoluteString ?? "nil"
        let path = urlStr.replacingOccurrences(of: "\(MoonDuckAPI.baseUrl())", with: "")
        if let body = request.request?.httpBody {
            let bodyString = String(bytes: body, encoding: .utf8) ?? "nil"
            let message: String = """
                                    
            ---------- HTTP REQUEST ----------
            path: \(path) - \(Date().debugDescription)
            url: \(urlStr)
            headers: \(headers)
            body: \(bodyString)
            --------------------------------
            
            """
            Log.network(message)
        } else {
            let message: String = """
                        
            ---------- HTTP REQUEST ----------
            path: \(path) - \(Date().debugDescription)
            url: \(urlStr)
            headers: \(headers)
            body: nil
            --------------------------------
            
            """
            Log.network(message)
        }
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        let request = response.request
        let urlStr = request?.url?.absoluteString ?? "nil"
        let method = request?.httpMethod ?? "nil"
        let statusCode = response.response?.statusCode ?? 0
        var bodyString = "nil"
        if let data = request?.httpBody,
           let string = String(bytes: data, encoding: .utf8) {
            bodyString = string
        }
        
        var responseString = "nil"
        let data = response.data
        if let responseStr = data?.toPrettyPrintedString {
            responseString = responseStr
        }
        
        let result = response.result

        let message: String = """
        
        ---------- HTTP RESPONSE ----------
        method : \(method)
        statusCode: \(statusCode)
        url: \(urlStr)
        body: \(bodyString)
        response: \(responseString)
        result: \(result)
        --------------------------------
        """
        Log.network(message)
    }
}
extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
