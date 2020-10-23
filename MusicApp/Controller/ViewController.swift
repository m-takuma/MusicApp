//
//  ViewController.swift
//  MusicApp
//
//  Created by 松尾卓磨 on 2020/10/21.
//  Copyright © 2020 松尾卓磨. All rights reserved.
//
import UIKit
import youtube_ios_player_helper
import Foundation
import Alamofire
import SwiftyJSON

let iso8601DurationPattern = "^PT(?:(\\d+)H)?(?:(\\d+)M)?(?:(\\d+)S)?$"
let iso8601DurationRegex = try! NSRegularExpression(pattern: iso8601DurationPattern, options: [])

func youtubeDuration (duration:String) -> (String,Int){
    if let match = iso8601DurationRegex.firstMatch(in: duration, options: [], range: NSRange(0..<duration.utf16.count)) {
        let hRange = match.range(at: 1)
        let hStr = (hRange.location != NSNotFound) ? (duration as NSString).substring(with: hRange) : ""
        let hInt = Int(hStr) ?? 0
        let mRange = match.range(at: 2)
        let mStr = (mRange.location != NSNotFound) ? (duration as NSString).substring(with: mRange) : ""
        let mInt = Int(mStr) ?? 0
        let sRange = match.range(at: 3)
        let sStr = (sRange.location != NSNotFound) ? (duration as NSString).substring(with: sRange) : ""
        let sInt = Int(sStr) ?? 0
        let durationFormatted =
            (hInt == 0)
            ? String(format: "%02d:%02d", mInt, sInt)
            : String(format: "%02d:%02d-%02d", hInt, mInt, sInt)
        let second = Int(3600 * hInt + 60 * mInt + sInt)
        return (durationFormatted,second)
    } else {
        print("bad format")
        return ("bad format",0)
    }
}

class ViewController: UIViewController, YTPlayerViewDelegate,UITextFieldDelegate,CatchVideoID{
    
    
    private let searchModel = SearchModel()
    private var alert:UIAlertController!
    
    @IBOutlet weak var musicPlayView: UIView!
    @IBOutlet weak var youtubeview: YTPlayerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeview.tag = 100
        musicPlayView.tag = 200
        self.youtubeview.delegate = self
        searchTextField.delegate = self
        if UserDefaults.standard.stringArray(forKey: "key") != []{
            var playlist:Array<String>! = UserDefaults.standard.stringArray(forKey: "key")
            playlist.shuffle()
            self.youtubeview.load(withVideoId: playlist[0], playerVars: ["playsinline":1])
        }else{
            self.youtubeview.load(withVideoId: "_RmyFTG0F_c", playerVars: ["playsinline":1])
        }
    }
    
    override func viewWillLayoutSubviews() {
        let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        if keyWindow != nil {
            let x = keyWindow!.subviews.filter{$0.tag == 200}
            if x == [] {
                //youtubeview.frame = CGRect(x: 0, y: 407, width: 375, height: 211)
                musicPlayView.frame = CGRect(x: 0,y: 528,width: 375,height: 90)
                keyWindow?.addSubview(self.musicPlayView)//(self.youtubeview)
            }
        }
    }
    @IBAction func tapButtonTemp(_ sender: UIButton) {
        let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        if keyWindow != nil {
            let x = keyWindow!.subviews.filter{$0.tag == 200}
            let tempview = x[0]
            let y = tempview.subviews.filter{$0.tag == 100}
            let play_youtube_view = y[0]
            if sender.tag == 1{
                tempview.frame = CGRect(x: 0,y: 0,width: 375,height: 667)
                let width = tempview.bounds.width
                let height = width * 9 / 16
                play_youtube_view.frame = CGRect(x: CGFloat(0), y: CGFloat(tempview.bounds.midY - height * 9 / 16 * 2), width: CGFloat(width), height: CGFloat(height))
                sender.frame = CGRect(x: CGFloat(tempview.bounds.width * 19 / 20 - 46), y: CGFloat(tempview.bounds.width * 1 / 20), width: 46, height: 30)
                sender.tag = 2
                sender.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            }else if sender.tag == 2{
                tempview.frame = CGRect(x: 0,y: 528,width: 375,height: 90)
                play_youtube_view.frame = CGRect(x:0,y:0, width: CGFloat(90 * 16 / 9),height:90)
                sender.frame = CGRect(x: CGFloat(tempview.bounds.width * 19 / 20 - 46), y: CGFloat(tempview.bounds.width * 1 / 30), width: 46, height: 30)
                sender.tag = 1
                sender.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            }
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {//動画再生の準備ができたときの処理
        playerView.playVideo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        if keyWindow != nil {
            let x = keyWindow!.subviews.filter{$0.tag == 200}
            if x != [] {
                //let tempView = x[0] as! YTPlayerView
                let playview = x[0].subviews.filter{$0.tag == 100}
                let tempView = playview[0] as! YTPlayerView
                tempView.load(withVideoId: Id, playerVars: ["playsinline":1])
                
                
            }
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended{//1曲ループ再生
            if UserDefaults.standard.object(forKey: "loop") as? Bool == true{
                playerView.playVideo()
            }
        }
    }
    
    private func makeAlertViewForErrorCode(code:Int){
        alert = UIAlertController.init(title: "エラー", message: "code:\(code)", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(
                    title: "OK",
            style: UIAlertAction.Style.cancel,
                    handler: nil)
        alert.addAction(alertAction)
    }
}

