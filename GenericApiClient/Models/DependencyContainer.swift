//
//  DependencyContainer.swift
//  GenericApiClient
//
//  Created by Dave Troupe on 3/12/20.
//  Copyright © 2020 High Tree Development. All rights reserved.
//

import UIKit

typealias Factory = DependencyContainerProtocol & ViewFactoryProtocol

protocol ViewFactoryProtocol {
  func makeContentView() -> ContentView
}

protocol DependencyContainerProtocol {
  var apiClient: GenericApiClient { get }
  var rocketViewModel: RocketViewModel { get }
}

final class DependencyContainer: DependencyContainerProtocol {
  private let urlSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 15 // seconds
    configuration.timeoutIntervalForResource = 30
    return URLSession(configuration: .default)
  }()

  private(set) lazy var apiClient: GenericApiClient = {
    return GenericApiClient(urlSession: self.urlSession)
  }()

  private(set) lazy var rocketViewModel: RocketViewModel = {
    return RocketViewModel(apiClient: self.apiClient)
  }()
}

// MARK: ViewFactory

extension DependencyContainer: ViewFactoryProtocol {
  func makeContentView() -> ContentView {
    return ContentView(factory: self)
  }
}
