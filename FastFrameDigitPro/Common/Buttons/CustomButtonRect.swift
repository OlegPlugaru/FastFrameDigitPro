//
//  CustomButtonRect.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 01.09.2023.
//

import SwiftUI

import SwiftUI

struct CustomActionButton: View {
    let action: () -> Void
    let label: String
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            Text(label)
                .frame(width: UIScreen.main.bounds.height > 680 ? UIDevice.current.userInterfaceIdiom == .pad ? 247 : 165 : 135, height: UIScreen.main.bounds.height > 680 ? UIDevice.current.userInterfaceIdiom == .pad ? 85 : 55 : 50)
                .foregroundStyle(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                )
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.82, y: 0.88),
                        endPoint: UnitPoint(x: 0.2, y: 0.11)
                    )
                    .cornerRadius(40)
                    .shadow(color: .black.opacity(0.35), radius: 18.02564, x: 7.21026, y: 10.81538)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .inset(by: 0.9)
                            .stroke(Color(red: 0.16, green: 0.17, blue: 0.18), lineWidth: 1.8)
                    )
                )
        }
        .opacity(isDisabled ? 0.5 : 1.0)
        .disabled(isDisabled)
        .padding(.top)
    }
}

