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
        print("🚀 [요청] \(request.httpMethod ?? "") \(url)")
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            print("✅ [성공: \(response.statusCode)] \(response.response?.url?.absoluteString ?? "")")
        case .failure(let error):
            print("❌ [실패] \(error.localizedDescription)")
        }
    }
}
