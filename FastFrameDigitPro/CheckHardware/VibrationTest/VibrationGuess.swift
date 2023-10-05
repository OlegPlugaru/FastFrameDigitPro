//
//  VibrationGuess.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI

struct VibrationGuess: View {
    @ObservedObject var vm: ContentModel
    @ObservedObject var vmTest: CheckHardwareVM
    @State var buttonNumbers = [Int]()
   
    init(vmTest:CheckHardwareVM, vm: ContentModel) {
        self.vmTest = vmTest
        self.buttonNumbers = generateRandomButtonNumbers(vibrationCount: vmTest.vibrationCount)
        self.vm = vm
        }
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        vmTest.coordinator.navigateTo(to: .firstView)
                        vm.isTabBarVisible = true
                        vmTest.successTestCount = 0
                        vmTest.successTestCount = 0.0
                        vmTest.buttonsTestPassed = false
                        vmTest.vibrationTestPassed = false
                        vmTest.chargerTestPassed = false
                        vmTest.proximityTestPassed = false
                        vmTest.vibrationCount = 0
                        vmTest.testPassed = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size:  UIScreen.main.bounds.height > 680 ? 20  : 16))
                            .padding(UIScreen.main.bounds.height > 680 ? 12  : 8)
                            .background {
                                Circle()
                                    .fill(LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.82, y: 0.88),
                                        endPoint: UnitPoint(x: 0.2, y: 0.11)
                                    )
                                    )
                                    .overlay {
                                        Circle()
                                            .inset(by: 1)
                                            .stroke(lineWidth: 1)
                                            .foregroundStyle(LinearGradient(colors: [Color(red: 0.16, green: 0.18, blue: 0.2),.clear ], startPoint: .bottomTrailing, endPoint: .top))
                                    }
                                    .shadow(color: .black.opacity(0.35), radius: 18, x: 7, y: 10)
                            }
                    }
                    .frame(width: 40, alignment: .leading)
                    Spacer()
                    Text(vmTest.coordinator.currentView.viewName)
                        .font(.system(size: UIScreen.main.bounds.height > 680 ? 24  : 20))
                        .foregroundColor(Color(red: 0.97, green: 0.98, blue: 0.99))
                    Spacer()
                    Image(systemName: "xmark")
                        .frame(width: 40)
                        .opacity(0)
                }
                .padding(.horizontal)
                Spacer()
                Text(vmTest.coordinator.currentView.viewText)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(width: 331, height: 37, alignment: .top)
                
                HStack {
                    Spacer()
                    ForEach(buttonNumbers, id: \.self) { number in
                        
                        RoundedButton(vmTest: vmTest, number: number)
                            .padding()
                      //  Spacer()
                    }
                  Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            buttonNumbers = generateRandomButtonNumbers(vibrationCount: vmTest.vibrationCount)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
              
            }
        }
        .onDisappear {
            vmTest.vibrationCount = 0
        }
    }
    
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct RoundedButton: View {
    @ObservedObject var vmTest: CheckHardwareVM
    var number: Int
    var body: some View {
        Button {
            if number == vmTest.vibrationCount {
                vmTest.navigateTo(to: .vibrationPassed)
            } else {
                vmTest.navigateTo(to: .vibrationFailed)
                vmTest.vibrationTestPassed = false
            }
        } label: {
            Text("\(number)")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding(20)
                .background {
                    Circle()
                        .fill(LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.82, y: 0.88),
                            endPoint: UnitPoint(x: 0.2, y: 0.11)
                        ))
                }
                .overlay {
                    Circle()
                        .inset(by: 1)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(LinearGradient(colors: [Color(red: 0.16, green: 0.18, blue: 0.2),.clear ], startPoint: .bottomTrailing, endPoint: .top))
                }
                .shadow(color: .black.opacity(0.35), radius: 18.02564, x: 7.21026, y: 10.81538)
                .padding(.top, 30)
        }
    }
}

func generateRandomButtonNumbers(vibrationCount: Int) -> [Int] {
    var numbers = Set<Int>() // Using a Set to avoid duplicates

    while numbers.count < 2 {
        let randomNum = Int.random(in: 1...9)
        if randomNum != vibrationCount {
            numbers.insert(randomNum)
        }
    }

    // Add the vibrationCount number separately
    numbers.insert(vibrationCount)

    // Convert the Set back to an Array
    let result = Array(numbers).shuffled()
    print(result)

    return result
}
