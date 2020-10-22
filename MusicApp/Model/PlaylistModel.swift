//
//  PlaylistModel.swift
//  MusicApp
//
//  Created by 松尾卓磨 on 2020/10/15.
//  Copyright © 2020 松尾卓磨. All rights reserved.
//

import Foundation

class PlaylistModel {
    private let SECRET = Secret()
    private var musicIdKeyArray:Array<String> = []//UserDefaultsに保存するための格納配列
    let KEY:String//"key"//UserDefaultに保存したIDの配列取得のKey
    
    
    init() {
        KEY = SECRET.KEY_PlaylistVideoIdUserDefault
        //UserDefaults.standard.removeAll()
        //UserDefaults.standard.removeObject(forKey: key)
        /*nilの場合エラーになるので、空配列を仮登録しておく*/
        if UserDefaults.standard.stringArray(forKey: KEY) == nil {
            UserDefaults.standard.setValue([], forKey: KEY)
        }
    }
        
    /*プレイリストに音楽を追加するメソッド*/
    func addMusicToPlaylist(id:String,title:String,image:String) -> Void {
        musicIdKeyArray = UserDefaults.standard.stringArray(forKey: KEY)!
        musicIdKeyArray.append(id)
        print(musicIdKeyArray)
        UserDefaults.standard.setValue(musicIdKeyArray, forKey: KEY)
        let musicInfo = ["id":id,"title":title,"image":image]
        UserDefaults.standard.setValue(musicInfo, forKey: id)
    }
    
    /*プレイリストから音楽を削除するメソッド*/
    func deleteMusicFromPlaylist(id:String) -> Void {
        musicIdKeyArray = UserDefaults.standard.stringArray(forKey: KEY)!
        if let atIndex =  musicIdKeyArray.firstIndex(of: id) {
            musicIdKeyArray.remove(at: atIndex)
            UserDefaults.standard.setValue(musicIdKeyArray, forKey: KEY)
            UserDefaults.standard.removeObject(forKey: id)
        }else{
            print("playlistから該当の曲は見つかりませんでした(PlaylistModel)")
        }
    }
    
    /*プレイリストに曲があるか検索するメソッド*/
    func searchMusic(id:String) -> Bool {
        musicIdKeyArray = UserDefaults.standard.stringArray(forKey: KEY)!
        let atIndex:Int? = musicIdKeyArray.firstIndex(of: id)
        if atIndex != nil {
            return true
        }else{
            return false
        }
    }
}

extension UserDefaults{
    /*UserDefalutsの情報を全て削除するメソッド*/
    func removeAll(){
        dictionaryRepresentation().forEach { removeObject(forKey: $0.key)}
    }
}
