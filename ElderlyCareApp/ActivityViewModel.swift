//
//  ActivityViewModel.swift
//  ElderlyCareApp
//
//  Created by MOHAN KUMMARIGUNTA on 9/16/24.
//

import SwiftUI
import Combine

class ActivityViewModel: ObservableObject {
    @Published var activities: [String] = []

    func addActivity(_ activity: String) {
        activities.append(activity)
    }
}
