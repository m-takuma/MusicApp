import UIKit
import youtube_ios_player_helper
import Foundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, YTPlayerViewDelegate,UITextFieldDelegate,CatchVideoID{
    
    
    let searchModel = SearchModel()
    var alert:UIAlertController!
    var a = 1
    
    @IBOutlet weak var youtubeview: YTPlayerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeview.tag = 100
        self.youtubeview.delegate = self
        searchTextField.delegate = self//画面読み込み時のところに書く
        self.youtubeview.load(withVideoId: "_RmyFTG0F_c", playerVars: ["playsinline":1])
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        let x = keyWindow!.subviews.filter{$0.tag == 100}
        if x == [] && a == 1{
            youtubeview.frame = CGRect(x: 0, y: 102, width: 375, height: 516)
            keyWindow?.addSubview(self.youtubeview)
        }
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {//動画再生の準備ができたときの処理
        self.youtubeview.playVideo()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //searchmodel.search(word: textField.text!)
        return textField.resignFirstResponder()
    }

    @IBAction func PushedSearchButton(_ sender: UIButton) {
        view.endEditing(true)
        let encodedUrl = searchModel.makeSearchUrl(word: searchTextField.text!)
        
        AF.request(encodedUrl,method: .get,parameters: nil,encoding: JSONEncoding.default).responseJSON { (res) in
            switch res.result{
            case .success:
                let json:JSON = JSON(res.data as Any)
                let trueOrFalse = self.searchModel.StartParse(json: json)
                if trueOrFalse {
                    self.performSegue(withIdentifier: "id", sender: nil)
                }else{
                    print("json解析でエラーが発生しました")
                    self.makeAlertViewForErrorCode(code: self.searchModel.errorCode)
                    self.present(self.alert, animated: true, completion: nil)
                }
            case .failure(_):
                print("json取得に失敗しました")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "id"{
            let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
            let x = keyWindow!.subviews.filter{$0.tag == 100}
            self.view.addSubview(x[0])
            a = 2
            let tableVC = segue.destination as! SearchResultsViewController
            tableVC.delegate = self
            tableVC.videotitleArray = searchModel.titleArray
            tableVC.videoImageArray = searchModel.videoImageArray
            tableVC.videoIdArray = searchModel.videoIDArray
            tableVC.searchWord = searchModel.word
            tableVC.nextPageToken = searchModel.nextPageToken
            tableVC.prevPageToken = searchModel.prevPageToken
        }
    }
    func CatchVideoIdAndPlayVideo(Id: String) {
        let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        let tempView = keyWindow?.viewWithTag(100)
        youtubeview.load(withVideoId: Id, playerVars: ["playsinline":1])
        youtubeview.frame = CGRect(x: 0, y: 102, width: 375, height: 516)
        keyWindow?.addSubview(self.youtubeview)
    }
    func makeAlertViewForErrorCode(code:Int){
        alert = UIAlertController.init(title: "エラー", message: "code:\(code)", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(
                    title: "OK",
            style: UIAlertAction.Style.cancel,
                    handler: nil)
        alert.addAction(alertAction)
    }
}

