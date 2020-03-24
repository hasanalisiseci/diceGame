//
//  ViewController.swift
//  diceGame
//
//  Created by Hasan Ali on 22.03.2020.
//  Copyright © 2020 Hasan Ali Şişeci. All rights reserved.
//

import UIKit
import AudioToolbox


class ViewController: UIViewController {
    
    @IBOutlet weak var skorLabel1: UILabel!
    @IBOutlet weak var skorLabel2: UILabel!
    @IBOutlet weak var dice1Label: UILabel!
    @IBOutlet weak var dice2Label: UILabel!
    @IBOutlet weak var playLabel1: UILabel!
    @IBOutlet weak var playLabel2: UILabel!
    @IBOutlet weak var diceImage2: UIImageView!
    @IBOutlet weak var diceImage1: UIImageView!
    
    //Değişkenlerimiz
    var playerPoints = (firstPlayerPoint : 0, secondPlayerPoint : 0)
    var playerScores = (firstPlayerScore : 0, secondPlayerScore : 0)
    var playersTurn : Int = 1
    var maxSet : Int = 5
    var nowSet : Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playLabel1.text = "Play"
        playLabel2.text = "Wait"
    }
    
    //Sallama hareketinden sonra olacakları gerçekleştiren fonksiyonumuz
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if nowSet > maxSet {
            return
        }
        
        //import ettiğimiz AuidoToolBox ile her sallama hareketinde titreşim sağlıyoruz
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
        diceValue()
    }
    
    //Set sonuçlarını belirleyen fonksiyonumuz
    func setResult(dice1 : Int, dice2 : Int) {
        if playersTurn == 1 {
            playerPoints.firstPlayerPoint = dice1 + dice2
            dice1Label.text = String(playerPoints.firstPlayerPoint)
            playLabel1.text = "Wait"
            playLabel2.text = "Play"
            playersTurn = 2
            dice2Label.text = String(0)
        } else {
            playerPoints.secondPlayerPoint = dice1 + dice2
            dice2Label.text = String(playerPoints.secondPlayerPoint)
            playLabel1.text = "Play"
            playLabel2.text = "Wait"
            playersTurn = 1
            

            
            if playerPoints.firstPlayerPoint > playerPoints.secondPlayerPoint {
                playerScores.firstPlayerScore += 1
                nowSet += 1
                skorLabel1.text = String(playerScores.firstPlayerScore)
                
            } else if playerPoints.firstPlayerPoint < playerPoints.secondPlayerPoint {
                playerScores.secondPlayerScore += 1
                nowSet += 1
                skorLabel2.text = String(playerScores.secondPlayerScore)
            }
        }
    }
    
    //Random zar atma işlemi
    func diceValue() {
        //DispatchQueue ile fonksiyonumuzun kaç saniye sonra gerçekleşeceğini seçiyoruz burada biz 1 saniye seçtik
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let dice1 = arc4random_uniform(6)+1
            let dice2 = arc4random_uniform(6)+1
            
            self.diceImage1.image = UIImage(named: "dice\(dice1)")
            self.diceImage2.image = UIImage(named: "dice\(dice2)")
            

            self.setResult(dice1: Int(dice1), dice2: Int(dice2))
            
            if self.nowSet > self.maxSet {
                if self.playerScores.firstPlayerScore > self.playerScores.secondPlayerScore {
                    self.makeAlert(whoWinner: "First Player")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.replay()
                    }
                } else {
                    self.makeAlert(whoWinner: "Second Player")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.replay()
                    }
                }
            }
        }
        
        
    }
    
    //Oyununu kazan için alert fonkisyonu
    func makeAlert(whoWinner : String) {
        let alert = UIAlertController(title: "\(playerScores.firstPlayerScore)-\(playerScores.secondPlayerScore)\nWINNER", message: "\(whoWinner) has won the game!", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    //Oyun bittiğinde tekrar etmesi için replay fonksiyonu
    func replay() {
        //Replay
        playerPoints = (firstPlayerPoint : 0, secondPlayerPoint : 0)
        playerScores = (firstPlayerScore : 0, secondPlayerScore : 0)
        playersTurn  = 1
        nowSet = 1
        skorLabel1.text = "0"
        skorLabel2.text = "0"
        diceImage1.image = UIImage(named: "dice")
        diceImage2.image = UIImage(named: "dice")
        dice1Label.text = "0"
        dice2Label.text = "0"

    }
}

