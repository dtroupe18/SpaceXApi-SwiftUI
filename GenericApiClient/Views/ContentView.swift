//
//  ContentView.swift
//  GenericApiClient
//
//  Created by Dave Troupe on 3/12/20.
//  Copyright © 2020 High Tree Development. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  private let factory: Factory

  @ObservedObject private var viewModel: RocketViewModel

  init(factory: Factory = DependencyContainer()) {
    self.factory = factory
    self.viewModel = factory.rocketViewModel
  }

  var body: some View {
    List(self.viewModel.rockets, id: \.id) { rocket in
      RocketView(rocket: rocket)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
