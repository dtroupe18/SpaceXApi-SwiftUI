//
//  RocketsViewModel.swift
//  GenericApiClient
//
//  Created by Dave Troupe on 3/13/20.
//  Copyright © 2020 High Tree Development. All rights reserved.
//

import Foundation
import Combine

final class RocketViewModel: ObservableObject {
  private let apiClient: GenericApiClient

  let objectWillChange = PassthroughSubject<RocketViewModel,Never>()

  init(apiClient: GenericApiClient) {
    self.apiClient = apiClient
    self.fetchRockets()
  }

  var rockets = [Rocket]() {
    didSet {
      objectWillChange.send(self)
    }
  }

  private func fetchRockets() {
    self.apiClient.getRockets(onSuccess: { [weak self] rocketResponse in
      self?.rockets = rocketResponse
    }, onError: { [weak self] error in
      print(error)
    })
  }
}
