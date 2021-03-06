//
//  GameOverViewController.swift
//  Kazu
//
//  Created by Nick Jones on 03/06/2015.
//  Copyright (c) 2015 Nick Jones. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController, UIGestureRecognizerDelegate {

    let viewHandler = ViewHandler()
    
    @IBOutlet var highScoreDifferenceLabel: UILabel!
    @IBOutlet var longestStreakLabel: UILabel!
    @IBOutlet var wrongAnswersLabel: UILabel!
    @IBOutlet var facebookShareButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var retryButton: UIButton!
    @IBOutlet var homeButton: UIButton!
    @IBAction func touchedRetry(sender: AnyObject) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        contentView.layer.cornerRadius = 2
    }
    
    func loadStats (stats: Stats) {
        scoreLabel.text = "\(stats.score)"
        wrongAnswersLabel.text = "\(stats.wrongAnswers)"
        longestStreakLabel.text = "\(stats.highestStreak)"
        var highScoreDifference = stats.calculateHighScoreDifference()
        if  highScoreDifference > 0 {
            highScoreDifferenceLabel.text = "+\(highScoreDifference)"
            return
        }
        highScoreDifferenceLabel.text = "\(highScoreDifference)"
    }
}
