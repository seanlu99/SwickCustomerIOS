//
//  TipPicker.swift
//  Customer
//
//  Created by Andrew Jiang on 10/20/20.
//

import SwiftUI

enum TipState {
    case later, low, med, high, custom
    
    var percent: Int? {
        switch self {
        case .low:
            return 15
        case .med:
            return 18
        case .high:
            return 20
        default:
            return nil
        }
    }
}

struct TipPicker: View {
    // Alerts
    @Binding var showCustomTip: Bool
    // Properties
    @Binding var tipState: TipState
    var removeLater: Bool = false
    
    func checkOtherSelected(_ tipState: TipState){
        if tipState == .custom {
            showCustomTip = true
        }
    }
    
    var body: some View {
        Picker("Tip", selection: $tipState.onChange(checkOtherSelected)) {
            if !removeLater {
                Text("Later").tag(TipState.later)
            }
            Text("\(TipState.low.percent!)%").tag(TipState.low)
            Text("\(TipState.med.percent!)%").tag(TipState.med)
            Text("\(TipState.high.percent!)%").tag(TipState.high)
            Text("Other").tag(TipState.custom)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct TipPicker_Previews: PreviewProvider {
    static var previews: some View {
        TipPicker(showCustomTip: .constant(false), tipState: .constant(.later))
    }
}
