//
//  ApiClient.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation


enum ApiEndpoint: String {
    case posts = "posts" 
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}


class ApiRequest {
    let method: HttpMethod
    let path: String
    
    init(method: HttpMethod, path: String) {
        self.method = method
        self.path = path
    }
}

struct ApiResponse<Body> {
    let statusCode: Int
    let body: Body
}

extension ApiResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type) throws -> ApiResponse<BodyType> {
        guard let data = body else {
            throw ApiError.decodingFailure
        }
        let decodedJSON = try JSONDecoder().decode(BodyType.self, from: data)
        return ApiResponse<BodyType>(statusCode: self.statusCode,
                                     body: decodedJSON)
    }
}

enum ApiError: Error {
    case invalidURL
    case requestFailed
    case decodingFailure
}

enum ApiResult<Body> {
    case success(ApiResponse<Body>)
    case failure(ApiError)
}

struct ApiClient {
    
    typealias APICompletion = (ApiResult<Data?>) -> Void
    
    private let session = URLSession.shared
    private let baseURL = URL(string: AppConfig.serverUrl)!
    
    func perform(_ request: ApiRequest, _ completion: @escaping APICompletion) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        
        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(.failure(.invalidURL)); return
        } 
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed)); return
            }
            completion(.success(ApiResponse<Data?>(statusCode: httpResponse.statusCode, body: data)))
        }
        task.resume()
    }
}


