//
//  Extensions.swift
//  LockedX
//
//  Created by Dumitru Paraschiv on 03.01.2022.
//

import SwiftUI
import SafariServices

extension Color {
	
//	static let lightBlue = Color(hex: "#0084C1")
//	static let darkBlue = Color(hex: "#040A46")
//	static let tabDarkBlue = Color(hex: "#000F35")
//	static let accentBlue = Color(hex: "#13C4FF")
	
}

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

final class UtilityUI {
	static func isSmallDevice() -> Bool {
		if (UIScreen.main.bounds.height < 680) {
			return true
		} else {
			return false
		}
	}
}

func customBackgroundGradient() -> LinearGradient {
    return LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.16, green: 0.18, blue: 0.2), location: 0.00),
            Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.1), location: 0.99),
        ],
        startPoint: UnitPoint(x: 0.5, y: 0),
        endPoint: UnitPoint(x: 0.5, y: 1)
    )
}
    
enum DeviceType{
    case phone, iPad
}

class UIDetector: ObservableObject{
    static var shared = UIDetector()

    @Published var device: DeviceType = .phone
    @Published var minilogo: String = "AppIcon"
    
    init(){
        self.setUp()
    }
    
    func setUp(){
        if UIDevice.current.userInterfaceIdiom == .pad {
            device = .iPad
        } else {
            device = .phone
        }
        self.minilogo = UserDefaults.standard.string(forKey: "appLogo") ?? "AppIcon"
    }
    
    func returnWidgetAplifier() -> Double{
        if device == .phone {
            return 1
        } else {
            return 1.5
        }
    }
    
    func returnTextBoost() -> CGFloat{
        if device == .phone {
            return 0
        } else {
            return 10
        }
    }
    
    func returnHorizontalPadding() -> CGFloat{
        if device == .phone {
            return 16
        } else {
            return 54
        }
    }
    
    func returnColumnGrid()-> [GridItem]{
        if device == .phone{
            return [GridItem(.flexible(minimum: 120, maximum: 300)),GridItem(.flexible(minimum: 120, maximum: 300)),GridItem(.flexible(minimum: 120, maximum: 300))]
        }else{
            return [GridItem(.flexible(minimum: 120, maximum: 300)),GridItem(.flexible(minimum: 120, maximum: 300)),GridItem(.flexible(minimum: 120, maximum: 300)),GridItem(.flexible(minimum: 120, maximum: 300))]
        }
    }
    
    func returnCGSize() -> CGSize{
        return CGSize(width: (UIScreen.main.bounds.width * 0.8) / (self.device == .phone ? 3 : 4), height: (UIScreen.main.bounds.width * 0.8) / (self.device == .phone ? 3 : 4))
        
    }
    
    func isPhoneSEModel() -> Bool {
        let screenHeight = UIScreen.main.bounds.height
        let seModelHeights: ClosedRange<CGFloat> = 568...667
        
        return seModelHeights.contains(screenHeight)
    }
}


extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

extension UIDevice {
    
    /**
     Returns device ip address. Nil if connected via celluar.
     */
    func getIP() -> String? {
        
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee
                
                guard let interface = ptr?.pointee else {
                    return nil
                }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    guard let ifa_name = interface.ifa_name else {
                        return nil
                    }
                    let name: String = String(cString: ifa_name)
                    
                    if name == "en0" {  // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                    
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
    
}

struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}


extension UIView {
       
       func allSubviews() -> [UIView] {
           var res = self.subviews
           for subview in self.subviews {
               let riz = subview.allSubviews()
               res.append(contentsOf: riz)
           }
           return res
       }
   }
   
   struct Tool {
       static func showTabBar() {
           UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
               if let view = v as? UITabBar {
                   view.isHidden = false
               }
           })
       }
       
       static func hiddenTabBar() {
           UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
               if let view = v as? UITabBar {
                   view.isHidden = true
               }
           })
       }
   }
   
   struct ShowTabBar: ViewModifier {
       func body(content: Content) -> some View {
           return content.padding(.zero).onAppear {
               Tool.showTabBar()
           }
       }
   }
   struct HiddenTabBar: ViewModifier {
       func body(content: Content) -> some View {
           return content.padding(.zero).onAppear {
               Tool.hiddenTabBar()
           }
       }
   }
   
   extension View {
       func showTabBar() -> some View {
           return self.modifier(ShowTabBar())
       }
       func hiddenTabBar() -> some View {
           return self.modifier(HiddenTabBar())
       }
   }
