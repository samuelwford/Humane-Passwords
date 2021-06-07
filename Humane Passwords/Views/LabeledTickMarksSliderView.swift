//
//  LabeledTickMarksSliderView.swift
//  Humane Passwords
//
//  Created by Samuel Ford on 6/7/21.
//

import SwiftUI

struct LabeledTickMarksSliderView: View {
    @Binding var length: Double
    
    var body: some View {
        Slider(value: $length, in: 6.0...16.0, step: 1.0, onEditingChanged: { _ in }) {
            Text("Length:")
        }
        
        // manually place labels beneath the tick marks
        Color.clear.frame(maxWidth: .infinity).frame(height: 1)
            .background(GeometryReader { proxy in
                Text("6")
                    .font(.caption)
                    .offset(x: 0, y: labelYOffset)
                    .onTapGesture {
                        length = 6.0
                    }
                ForEach(1..<10) { i in
                    Text("\(i + 6)")
                        .font(.caption)
                        .frame(width: 16, alignment: .center)
                        .offset(x: CGFloat(i) * ((proxy.size.width - 7) / 10.0) - 3, y: labelYOffset)
                        .onTapGesture {
                            length = Double(i + 6)
                        }
                }
                Text("16")
                    .font(.caption)
                    .offset(x: proxy.size.width - 10, y: labelYOffset)
                    .onTapGesture {
                        length = 16.0
                    }
            })
    }
}

struct LabeledTickMarksSliderView_Previews: PreviewProvider {
    static var previews: some View {
        LabeledTickMarksSliderView(length: .constant(8.0))
    }
}
