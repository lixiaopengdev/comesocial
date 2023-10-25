//
//  Server.swift
//  CSConstants
//
//  Created by 于冬冬 on 2023/3/27.
//

public extension Constants {
    
    struct Server {
        public static var domainEnviroment = Environment.getDefult()
        
        public static var baseURL: String {
            switch domainEnviroment {
            case .dev:
                return "http://192.168.50.193"
            case .mini:
                return "http://192.168.50.169:9999"
            case .aws:
                return "http://zingy.land"
            case .ali:
                return "http://39.106.26.162:9999"
            case .irelandTest:
                return "http://test.zingy.social"
            case .ireland:
                return "https://zingy.social"
            }
        }
    
                
        public static var wsURL: String {
            switch domainEnviroment {
            case .dev:
                return "ws://192.168.50.193"
            case .mini:
                return "ws://192.168.50.169"
            case .aws:
                return "ws://zingy.land"
            case .ali:
                return "ws://39.106.26.162:9999"
            case .irelandTest:
                return "ws://test.zingy.social"
            case .ireland:
                return "ws://zingy.social"

            }
        }
        
        public static let schemeURL = "comesocial://"
    }
    
    enum Environment: String {
        case dev
        case mini
        case aws
        case ali
        case irelandTest
        case ireland

        public func save() {
            UserDefaults.standard.set(self.rawValue, forKey: "Environment")
            UserDefaults.standard.synchronize()
        }
        
        static func getDefult() -> Environment {
//#if DEBUG
            let value = UserDefaults.standard.object(forKey: "Environment") as? String ?? ""
            return Environment(rawValue: value) ?? .ireland
//#endif
//            return .aws
        }
    }
}

