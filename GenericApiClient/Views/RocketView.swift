//
//  RocketView.swift
//  GenericApiClient
//
//  Created by Dave Troupe on 3/14/20.
//  Copyright © 2020 High Tree Development. All rights reserved.
//

import SwiftUI

struct RocketView: View {
  // @Binding var rocket: Rocket
  let rocket: Rocket

//  init(rocket: Binding<Rocket>) {
//    // Weird _ is required.
//    self._rocket = rocket
//  }

  init(rocket: Rocket) {
    self.rocket = rocket
  }

  var activeText: String {
    rocket.active ? "True" : "False"
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8, content: {
      RocketInfoRow(nameText: "Name:", valueText: rocket.rocketName)
      RocketInfoRow(nameText: "Active", valueText: activeText)
    })
  }
}

struct RocketView_Previews: PreviewProvider {
  static var previews: some View {
    RocketView(rocket: makeFakeRocket())
  }

  private static func makeFakeRocket() -> Rocket {
    // Make up a rocket so we can use our preview.
    let diameter = Diameter(meters: 10, feet: 10)
    let payloadWeight = PayloadWeight(id: "1", name: "payload", kg: 50, lb: 100)
    let thrust = Thrust(kN: 50, lbf: 50)
    let landingLegs = LandingLegs(number: 3, material: "metal")

    let payloads = Payloads(
      option1: "payload option",
      compositeFairing: CompositeFairing(height: diameter, diameter: diameter),
      option2: nil
    )

    let firstStage = FirstStage(
      reusable: true,
      engines: 9,
      fuelAmountTons: 10,
      burnTimeSEC: 75,
      thrustSeaLevel: thrust,
      thrustVacuum: thrust,
      cores: 3
    )

    let secondStage = SecondStage(
      engines: 4,
      fuelAmountTons: 5,
      burnTimeSEC: 90,
      thrust: thrust,
      payloads: payloads
    )

    let engines = Engines(
      number: 1,
      type: "",
      version: "",
      layout: nil,
      engineLossMax: nil,
      propellant1: "",
      propellant2: "",
      thrustSeaLevel: thrust,
      thrustVacuum: thrust,
      thrustToWeight: 2
    )

    return Rocket(
      id: 37,
      active: false,
      stages: 3,
      boosters: 3,
      costPerLaunch: 10000,
      successRatePct: 50,
      firstFlight: "today",
      country: "usa",
      company: "spaceX",
      height: diameter,
      diameter: diameter,
      mass: Mass(kg: 2, lb: 4),
      payloadWeights: [payloadWeight],
      firstStage: firstStage,
      secondStage: secondStage,
      engines: engines,
      landingLegs: landingLegs,
      wikipedia: "www.wikipedia.com",
      rocketResponseDescription: "description",
      rocketID: "rocketID",
      rocketName: "Rocket name",
      rocketType: "Rocket type"
    )
  }
}
