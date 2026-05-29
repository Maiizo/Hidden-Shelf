//
//  HiddenShelfWidgetBundle.swift
//  HiddenShelfWidget
//
//  Created by student on 29/05/26.
//

import WidgetKit
import SwiftUI

@main
struct HiddenShelfWidgetBundle: WidgetBundle {
    var body: some Widget {
        HiddenShelfWidget()
        HiddenShelfWidgetControl()
        HiddenShelfWidgetLiveActivity()
    }
}
