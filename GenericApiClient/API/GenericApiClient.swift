//
//  GenericApiClient.swift
//  GenericApiClient
//
//  Created by Dave Troupe on 3/12/20.
//  Copyright © 2020 High Tree Development. All rights reserved.
//

import Foundation

typealias ErrorCallback = (Error) -> Void
typealias DecodableCallback<T: Decodable> = (T) -> Void

/**
 Errors returned from GenericApiClient.
 */
enum NetworkError: Swift.Error {
  case noData
  case decodeFailed
  case urlCreation

  var localizedDescription: String {
    switch self {
    case .noData:
      return "No response from server please try again."
    case .decodeFailed:
      return "The server response is missing data. Please try again."
    case .urlCreation:
      return "The was an issue completing your request. Please try again."
    }
  }
}

final class GenericApiClient {
  private let urlSession: URLSession

  init(urlSession: URLSession) {
    self.urlSession = urlSession
  }

  private func createUrlRequest(for url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.setValue("Content-type", forHTTPHeaderField: "application/json")

    // Add the other headers you need like authorization
    return request
  }

  /**
  Performs a URL request and returns the `DecodableType` or an error.
  - parameter request: URLRequest to perform.
  - parameter decodableType: Any Type that conforms to Decodable.
  - parameter onSuccess: DecodableCallback = (Decodable) -> Void
  - parameter onError: ErrorCallback = (Error) -> Void
  */
  public func makeRequest<T: Decodable>(
    request: URLRequest,
    decodableType: T.Type,
    onSuccess: DecodableCallback<T>?,
    onError: ErrorCallback?
  ) {

    let task = self.urlSession.dataTask(with: request) { [weak self] data, response, error in
      if let err = error {
        DispatchQueue.main.async {
          onError?(err)
        }
        return
      }

      guard let data = data else {
        DispatchQueue.main.async {
          onError?(NetworkError.noData)
        }
        return
      }

#if DEBUG
      self?.logJson(data)
#endif

      do {
        // Decoding on a background thread.
        let decodedType = try JSONDecoder().decode(decodableType, from: data)
        DispatchQueue.main.async {
          onSuccess?(decodedType)
        }
      } catch let err {
        DispatchQueue.main.async {
          onError?(err)
        }
      }
    }
    task.resume()
  }

  public func getRockets(onSuccess: DecodableCallback<RocketResponse>?, onError: ErrorCallback?) {
    let url = ApiRoute.rockets.url
    let request = URLRequest(url: url)
    self.makeRequest(
      request: request,
      decodableType: RocketResponse.self,
      onSuccess: onSuccess,
      onError: onError
    )
  }
}

extension URLRequest {
  var debugString: String {
    var dict = allHTTPHeaderFields ?? [:]
    dict["url"] = url?.absoluteString
    dict["method"] = httpMethod

    return dict.asJsonString
  }
}

extension Dictionary {
  var asJsonString: String {
    let invalidJson = "invalid JSON"
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
      return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
    } catch {
      return invalidJson
    }
  }
}

extension Data {
  var asJsonString: String? {
    if let dict = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
      return dict.asJsonString
    }

    return nil
  }
}

#if DEBUG
extension GenericApiClient {
  private func logJson(_ data: Data) {
    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers), let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
        print(String(decoding: jsonData, as: UTF8.self))
    } else {
        print("json data malformed")
    }
  }
}
#endif
