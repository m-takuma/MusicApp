//
//  PlaylistModel.swift
//  MusicApp
//
//  Created by 松尾卓磨 on 2020/10/15.
//  Copyright © 2020 松尾卓磨. All rights reserved.
//

import Foundation

class PlaylistModel {
    let key = "key"
    var musicIdKeyArray:Array<String> = []
    //var musicInfo:Dictionary<String,(Id:String,title:String,image:String)> = [:]
    
    init() {
        //UserDefaults.standard.removeAll()
        //UserDefaults.standard.removeObject(forKey: key)
        if UserDefaults.standard.stringArray(forKey: key) == nil {
            UserDefaults.standard.setValue([], forKey: key)
        }else{
            print("プレイリストは既にあります")
        }
    }
    
    func addMusicToPlaylist(id:String,title:String,image:String) -> Void {
        musicIdKeyArray = UserDefaults.standard.stringArray(forKey: key)!
        musicIdKeyArray.append(id)
        print(musicIdKeyArray)
        UserDefaults.standard.setValue(musicIdKeyArray, forKey: key)
        let musicInfo = ["id":id,"title":title,"image":image]
        UserDefaults.standard.setValue(musicInfo, forKey: id)
    }
    
    func deleteMusicFromPlaylist(id:String) -> Void {
        musicIdKeyArray = UserDefaults.standard.stringArray(forKey: key)!
        if let atIndex =  musicIdKeyArray.firstIndex(of: id) {
            musicIdKeyArray.remove(at: atIndex)
            UserDefaults.standard.setValue(musicIdKeyArray, forKey: key)
            UserDefaults.standard.removeObject(forKey: id)
        }else{
            print("playlistから該当の曲は見つかりませんでした(PlaylistModel)")
        }
    }
    
    func searchMusic(id:String) -> Bool {
        musicIdKeyArray = UserDefaults.standard.stringArray(forKey: key)!
        let atIndex:Int? = musicIdKeyArray.firstIndex(of: id)
        if atIndex != nil {
            return true
        }else{
            return false
        }
    }
}

extension UserDefaults{
    func removeAll(){
        dictionaryRepresentation().forEach { removeObject(forKey: $0.key)}
    }
}
