//
//  NetworkLogger.swift
//  Totori
//
//  Created by 정윤아 on 4/2/26.
//

import Foundation

import Moya

final class NetworkLogger: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        guard let request = request.request, let url = request.url else { return }
        Logger.request(method: request.httpMethod ?? "", url: url.absoluteString)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            Logger.response(statusCode: response.statusCode, url: response.response?.url?.absoluteString ?? "")
            
            if let prettyJsonString = response.data.prettyPrintedJSONString {
                print("\(prettyJsonString)")
            } else {
                Logger.responseBody(response.data)
            }
            
        case .failure(let error):
            Logger.error(.network, error.localizedDescription)
        }
    }
}

extension Data {
    var prettyPrintedJSONString: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .withoutEscapingSlashes]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
}
