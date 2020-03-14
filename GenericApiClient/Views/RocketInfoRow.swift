//
//  RocketInfoRow.swift
//  GenericApiClient
//
//  Created by Dave Troupe on 3/14/20.
//  Copyright © 2020 High Tree Development. All rights reserved.
//

import SwiftUI

struct RocketInfoRow: View {
  let nameText: String
  let valueText: String

  init(nameText: String, valueText: String) {
    self.nameText = nameText
    self.valueText = valueText
  }

  var body: some View {
    HStack(alignment: .top, spacing: 0, content: {
      Text(self.nameText).bold()
      Text(self.valueText)
    })
  }
}

struct RocketInfoRow_Previews: PreviewProvider {
  static var previews: some View {
    RocketInfoRow(nameText: "Name:", valueText: "10")
  }
}
