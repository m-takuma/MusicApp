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

class ViewController: UIViewController, YTPlayerViewDelegate,UITextFieldDelegate,CatchVideoID{
    
    
    private let searchModel = SearchModel()
    private var alert:UIAlertController!
    
    @IBOutlet weak var youtubeview: YTPlayerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeview.tag = 100
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
            let x = keyWindow!.subviews.filter{$0.tag == 100}
            if x == [] {
                youtubeview.frame = CGRect(x: 0, y: 407, width: 375, height: 211)
                keyWindow?.addSubview(self.youtubeview)
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
            let x = keyWindow!.subviews.filter{$0.tag == 100}
            if x != [] {
                let tempView = x[0] as! YTPlayerView
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

