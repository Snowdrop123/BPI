//
//  API.swift
//  BPI
//
//  Created by Admin on 6/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

public enum APIErrors: Error {
    
    case apiError(Int, String?)
    
    case timeoutRequest
    case networkConnection
    case invalidUrl
    case badResponse
    case taskCancelled
    case wrongJsonDecode
    case serverError
    
    public func getError() -> Error {
        
        switch self {
        case .apiError(let statusCode, let errorMessage):
            return NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage ?? "Внутренняя ошибка"])
        case .timeoutRequest:
            return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Время ожидания истекло"])
        case .networkConnection:
            return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Проверьте интернет соединение"])
        case .invalidUrl:
            return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Неверный адрес запроса"])
        case .badResponse:
            return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ошибка сервера"])
        case .taskCancelled:
            return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Запрос отменен"])
        case .wrongJsonDecode:
            return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ошибка обработки запроса"])
        case .serverError:
            return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Общая ошибка сервера"])
        }
        
    }
    
}

struct APIError: Codable {
    var errorCode: Int
    var errorDescr: String?
}

public class API {
    
    public init() {
        
    }
    
    static public let sharedInstance = API()
    
    private var logoutAction: (() -> ())?
    
    public func setupLogoutAction(logoutAction: @escaping (() -> ())) {
        self.logoutAction = logoutAction
    }
    
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    private func dataTaskRequest(session: URLSession, urlRequest: URLRequest, completion: @escaping (Result<Data?, APIErrors>) -> ()) -> URLSessionDataTask {
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if let error = error {
                    
                    let code = (error as NSError).code
                    
                    if (code == NSURLErrorTimedOut) {
                        completion(.failure(.timeoutRequest))
                        return
                    }
                    
                    if code == NSURLErrorCancelled {
                        completion(.failure(.taskCancelled))
                        return
                    }
                    completion(.failure(.badResponse))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.serverError))
                    return
                }
                
                let statusCode = httpResponse.statusCode
                                
                guard statusCode == 200 else {
                                        
                    guard let data = data, let apiError = try? JSONDecoder().decode(APIError.self, from: data) else {
                        completion(.failure(.wrongJsonDecode))
                        return
                    }
                    
                    
                    completion(.failure(.apiError(statusCode, apiError.errorDescr)))
                    return
                    
                }
                
                completion(.success(data))
                
            }
            
        }
        
        task.resume()
        
        return task
        
    }
        
    private func getURLRequest(method: HTTPMethod, url: URL, headers: [String: String]?, parameters: Data?) -> URLRequest {

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = parameters
        return request

    }
    
    private func getURLSession(timeout: Double?) -> URLSession {
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeout ?? 10
        sessionConfig.timeoutIntervalForResource = timeout ?? 10
        return URLSession(configuration: sessionConfig)
        
    }
    
    private func getQueryItemsUrl(url: String, queryItems: [String: String?]?) -> URL? {
        
        guard let urlComponents = NSURLComponents(string: url) else {
            return nil
        }
        
        guard let queryItems = queryItems, queryItems.count > 0 else {
            return urlComponents.url
        }
        
        var urlQueryItems: [URLQueryItem] = []
        
        for parameter in queryItems {
            urlQueryItems.append(URLQueryItem(name: parameter.key, value: parameter.value))
        }
        
        urlComponents.queryItems = urlQueryItems
        
        return urlComponents.url
        
    }
    
}

extension API {
    
    func getModelRequest<T: Decodable>(method: API.HTTPMethod, url: String, queryItems: [String: String?]?, timeout: Double?, headers: [String: String]?, parameters: Data?, objectType: T.Type, completion: @escaping (Result<T, APIErrors>) -> Void) -> URLSessionDataTask? {
        
        return getDataRequest(method: method, url: url, queryItems: queryItems, timeout: timeout, headers: headers, parameters: parameters) { (result) in
            switch result {
            case .success(let data):
                                
                guard let jsonData = data, let object = try? JSONDecoder().decode(objectType, from: jsonData) else {
                    completion(.failure(APIErrors.wrongJsonDecode))
                    return
                }
                completion(.success(object))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}

extension API {
    
    func getDictionaryRequest(method: API.HTTPMethod, url: String, queryItems: [String: String?]?, timeout: Double?, headers: [String: String]?, parameters: Data?, completion: @escaping (Result<[String: Any], APIErrors>) -> Void) -> URLSessionDataTask? {
        
        return getDataRequest(method: method, url: url, queryItems: queryItems, timeout: timeout, headers: headers, parameters: parameters) { (result) in
            
            switch result {
            case .success(let data):
                guard let jsonData = data, let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                    completion(.failure(APIErrors.wrongJsonDecode))
                    return
                }
                
                completion(.success(dictionary))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
            
        }
        
    }
    
}

extension API {
    
    func getDataRequest(method: API.HTTPMethod, url: String, queryItems: [String: String?]?, timeout: Double?, headers: [String: String]?, parameters: Data?, completion: @escaping (Result<Data?, APIErrors>) -> Void) -> URLSessionDataTask? {
        
        guard let url = getQueryItemsUrl(url: url, queryItems: queryItems) else {
            completion(.failure(APIErrors.invalidUrl))
            return nil
        }
        
        let session = getURLSession(timeout: timeout)
        let urlRequest = getURLRequest(method: method, url: url, headers: headers, parameters: parameters)
        
        let task = dataTaskRequest(session: session, urlRequest: urlRequest, completion: completion)
        return task
        
    }
    
}
