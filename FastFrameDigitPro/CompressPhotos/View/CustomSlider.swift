//
//  CustomSlider.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI

struct CustomSlider<V>: View where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
    @Binding private var value: V
    private let bounds: ClosedRange<V>
    private let step: V.Stride
    private let length: CGFloat    = 50
    private let lineWidth: CGFloat = 2
    @State private var ratio: CGFloat   = 0
    @State private var startX: CGFloat? = nil
    
    init(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1) {
        _value  = value
        self.bounds = bounds
        self.step   = step
    }
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: length / 2)
                    .foregroundStyle(LinearGradient(
                        stops: [
                            Gradient.Stop(color:Color(red: 0.08, green: 0.08, blue: 0.08),location: 0.00),
                            Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    ))
                    .frame(width: proxy.size.width, height: 10)
                RoundedRectangle(cornerRadius: length / 2)
                    .foregroundStyle(LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.8, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    ))
                    .frame(width: (proxy.size.width - length + 8) * ratio + length/2, height: 10)
                Image("Line")
                    .foregroundColor(.white)
                    .frame(width: length, height: 30)
                    .offset(x: (proxy.size.width - length + 8) * ratio, y: 5)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ updateStatus(value: $0, proxy: proxy) })
                        .onEnded { _ in startX = nil })
            }
            .frame(height: 30)
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged({ update(value: $0, proxy: proxy) }))
            .onAppear {
                ratio = min(1, max(0,CGFloat(value / bounds.upperBound)))
            }
        }
    }
    
    private var overlay: some View {
        RoundedRectangle(cornerRadius: (5 + lineWidth) / 2)
            .stroke(Color.gray, lineWidth: lineWidth)
            .frame(height: length + lineWidth)
    }
    
    
    // MARK: - Function
    // MARK: Private
    private func updateStatus(value: DragGesture.Value, proxy: GeometryProxy) {
        guard startX == nil else { return }
        
        let delta = value.startLocation.x - (proxy.size.width - length) * ratio
        startX = (length < value.startLocation.x && 0 < delta) ? delta : value.startLocation.x
    }
    
    private func update(value: DragGesture.Value, proxy: GeometryProxy) {
        guard let x = startX else { return }
        startX = min(length, max(0, x))
        
        var point = value.location.x - x
        let delta = proxy.size.width - length
        
        // Check the boundary
        if point < 0 {
            startX = value.location.x
            point = 0
        } else if delta < point {
            startX = value.location.x - delta
            point = delta
        }
        
        // Ratio
        var ratio = point / delta
        
        // Step
        if step != 1 {
            let unit = CGFloat(step) / CGFloat(bounds.upperBound)
            
            let remainder = ratio.remainder(dividingBy: unit)
            if remainder != 0 {
                ratio = ratio - CGFloat(remainder)
            }
        }
        
        self.ratio = ratio
        self.value = V(bounds.upperBound) * V(ratio)
        
        // Format the value without trailing zeroes
        let formattedValue = String(format: "%.0f", self.value as! CVarArg)
        print("Slider value: \(formattedValue)")
    }
}

import SwiftUI

struct Demo: View {
    
    // MARK: - Value
    // MARK: Private
    @State private var number = 0.0
    
    
    // MARK - View
    // MARK: Public
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10) {
                Text("Number\n\(number)")
                    .bold()
                    .padding(.bottom, 20)
                
                Text("OS Slider")
                Slider(value: $number, in: 0...100, step: 0.10)
                    .padding(.bottom, 20)
                
                Text("Custom Slider")
                CustomSlider(value: $number, in: 0...100, step: 25.0)
                //  .padding(.bottom, 20)
                    .frame(height: 30)
                
                //  .background(.green)
            }
            .padding(20)
        }
    }
}

struct Demo_Previews: PreviewProvider {
    static var previews: some View {
        Demo()
    }
}

