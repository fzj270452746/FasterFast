import UIKit
import WebKit
import AppsFlyerLib

private var Moize = [String]()
//internal var HuntOrderKrajs = [String()]

//rechargeClick,amount,recharge,jsBridge,withdrawOrderSuccess,params,firstrecharge,firstCharge,charge,currency,addToCart,openWindow,deposit

let Brie = Moize[0]              //jsBridge
let NBrie = Moize[1]  //
let amt = Moize[2]     //amount
let ren = Moize[3]      //currency
let OpWin = Moize[4]      //openWindow
let MUnt = Moize[5]       //USD
let EvKy = Moize[6]       //eventKey
let EvVue = Moize[7]      //eventValue

//let diaChon = husnOjauehs[0]      //rechargeClick
//let amt = husnOjauehs[1]     //amount
//let chozh = husnOjauehs[2]      //recharge
//let Brie = husnOjauehs[3]              //jsBridge
//let hdrawo = husnOjauehs[4]   //withdrawOrderSuccess
//let rams = husnOjauehs[5]      //params
//let diyicicho = husnOjauehs[6]      //firstrecharge
//let diyichCha = husnOjauehs[7]    //firstCharge
//let geicho = husnOjauehs[8]         //charge
//let ren = husnOjauehs[9]      //currency
//let aTc = husnOjauehs[10]  //addToCart
//let OpWin = husnOjauehs[11]      //openWindow
//let deop = husnOjauehs[12]       //deposit


internal class GioznbVsheuViewController: UIViewController,WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    var ndjiea: Poinsh?
    var kcinae: WKWebView?
    
    private var kaoieus: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ndjiea!.basunsk != nil {
            view.backgroundColor = UIColor.init(hexString: ndjiea!.basunsk!)
        }
        
        AppsFlyerLib.shared().appsFlyerDevKey = ndjiea!.cyaiwem!
        AppsFlyerLib.shared().appleAppID = ndjiea!.masjiu!
        AppsFlyerLib.shared().start { res, err in
            if (err != nil) {
                print(err as Any)
            }
        }
//        let aaq = ADJConfig(appToken: sinakeo!.qtzbzse!, environment: ADJEnvironmentProduction)
////        aaq?.delegate = self
//        Adjust.initSdk(aaq)
//        
        
        Moize = ndjiea!.teyausf!.components(separatedBy: ",")
//        HuntOrderKrajs = [aTc,diaChon, diyicicho, hdrawo, geicho, chozh, diyichCha, deop]
//        let usrScp = WKUserScript(source: ndjiea!.epoama!, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let usCt = WKUserContentController()
//        usCt.addUserScript(usrScp)
        let cofg = WKWebViewConfiguration()
        cofg.userContentController = usCt
        cofg.allowsInlineMediaPlayback = true
        cofg.userContentController.add(self, name: NBrie)
        cofg.defaultWebpagePreferences.allowsContentJavaScript = true
        kcinae = WKWebView(frame: .zero, configuration: cofg)
        kcinae!.allowsBackForwardNavigationGestures = true
        kcinae?.uiDelegate = self
        kcinae?.navigationDelegate = self
        view.addSubview(kcinae!)
        
        
        kaoieus = ndjiea!.wapsmj!
        kcinae?.load(URLRequest(url:URL(string: kaoieus!)!))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarManager = ws.statusBarManager {
            
            let statusBarHeight = ndjiea!.mqoiasn!.contains("V") ? statusBarManager.statusBarFrame.height : 0
            let bottomHeight = ndjiea!.mqoiasn!.contains("I") ? view.safeAreaInsets.bottom : 0
            kcinae?.frame = CGRectMake(0, statusBarHeight, view.bounds.width, view.bounds.height - statusBarHeight - bottomHeight)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        let ul = navigationAction.request.url
        if ((ul?.absoluteString.hasPrefix(webView.url!.absoluteString)) != nil) {
            UIApplication.shared.open(ul!)
//            webView.load(navigationAction.request)
        }
        return nil
    }
    
//    @objc private func eabsuhd(_ btn:UIButton) {
//        let v = btn.superview
//        v?.removeFromSuperview()
//    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == NBrie {
            let dic = message.body as! String
            WaisnVgzu(dic)
        }
    }
    
    override var shouldAutorotate: Bool {
        true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .allButUpsideDown
    }
}


//internal class EachCompareNavigationController: UINavigationController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        isNavigationBarHidden = true
//    }
//    
//    override var shouldAutorotate: Bool {
//        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
//    }
//}
