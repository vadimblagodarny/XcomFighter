//
//  Audio.swift
//  XcomFighter
//
//  Created by Vadim Blagodarny on 22.09.2023.
//

import AVFoundation

class Audio {
    static let shared = Audio()
    var musicPlayer: AVAudioPlayer?
    
    func startBackgroundMusic(backgroundMusicFileName: String) {
        if let bundle = Bundle.main.url(forResource: backgroundMusicFileName, withExtension: "mp3") {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: bundle)
                guard let audioPlayer = musicPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func stopBackgroundMusic() {
        guard let audioPlayer = musicPlayer else { return }
        audioPlayer.stop()
    }
}
