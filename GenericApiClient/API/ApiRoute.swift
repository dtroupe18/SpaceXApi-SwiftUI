//
//  ApiRoute.swift
//  GenericApiClient
//
//  Created by Dave Troupe on 3/12/20.
//  Copyright © 2020 High Tree Development. All rights reserved.
//

import Foundation

enum ApiRoute: String, CaseIterable {
  case rockets

  private var apiEndPoint: String {
    return "https://api.spacexdata.com/v3"
  }

  var url: URL {
    switch self {
    case .rockets:
      // OK to force unwrap because we test this.
      return URL(string: "\(apiEndPoint)/\(self.rawValue)")!
    }
  }
}
