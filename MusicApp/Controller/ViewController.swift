import UIKit
import youtube_ios_player_helper
import Foundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, YTPlayerViewDelegate,UITextFieldDelegate,CatchVideoID{
    
    
    let searchModel = SearchModel()
    var alert:UIAlertController!
    
    @IBOutlet weak var youtubeview: YTPlayerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.youtubeview.delegate = self
        searchTextField.delegate = self//画面読み込み時のところに書く
        self.youtubeview.load(withVideoId: "_RmyFTG0F_c", playerVars: ["playsinline":1])
        // Do any additional setup after loading the view.
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
        self.youtubeview.load(withVideoId: Id, playerVars: ["playsinline":1])
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

