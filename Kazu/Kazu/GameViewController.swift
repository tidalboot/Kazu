
import UIKit
import AVFoundation
import SpriteKit

class GameViewController: UIViewController, UIPopoverControllerDelegate {
    
    let randomNumberCalculator = RandomNumberCalculator()
    let gameHandler = GameHandler()
    let soundHandler = SoundHandler()
    let nodeHandler = NodeHandler()
    let highScoreHandler = HighScoreHandler()
    let viewHandler = ViewHandler()
    let stats = Stats()
    
    @IBOutlet var augendLabel: UILabel!
    @IBOutlet var addendLabel: UILabel!
    @IBOutlet var summationLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var correctLabel: UILabel!
    @IBOutlet var incorrectLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var operatorLabel: UILabel!
    @IBOutlet var equalsLabel: UILabel!
    @IBOutlet var countDownLabel: UILabel!
    
    //Button Outlets
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!

    //Ahhhh lovely variables
    var successAudioPlayer = AVAudioPlayer()
    var failAudioPlayer = AVAudioPlayer()
    var countdownAudioPlayer = AVAudioPlayer()
    var myTimer = NSTimer()
    var countDownTimer = NSTimer()
    var firstNumber: Int = 0
    var secondNumber: Int = 0
    var countDown = 4
    var timeLeft = 10.0
    var answerIsCorrect: Bool!
    var gameTypeToLoad: GameMode!
    var gameOverViewController: GameOverViewController!
    
    override func viewDidLoad() {
        let gameOverStoryboardView: AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("GameOver")
        gameOverViewController = gameOverStoryboardView as! GameOverViewController
        let popoverView = gameOverViewController.view
 
        gameOverViewController.homeButton.addTarget(self, action: "goHome", forControlEvents: UIControlEvents.TouchUpInside)
        gameOverViewController.retryButton.addTarget(self, action: "clickedRetry", forControlEvents: UIControlEvents.TouchUpInside)

        stats.gameMode = gameTypeToLoad
        operatorLabel.text = gameTypeToLoad.rawValue
        
        successAudioPlayer = soundHandler.createAudioPlayer("Pop_Success", extensionOfSound: "mp3")
        failAudioPlayer = soundHandler.createAudioPlayer("Pop_Fail", extensionOfSound: "mp3")
        countdownAudioPlayer = soundHandler.createAudioPlayer("Countdown", extensionOfSound: "mp3")
        startCountdown()
    }
    
    func goHome () {
        self.performSegueWithIdentifier("homeSegue", sender: self)
    }
    
    func startCountdown () {
        let genericView = UILabel()
        viewHandler.addPopoverViewWithFade(genericView, viewControllerToFade: self)
        countDownLabel.hidden = false
        self.view.bringSubviewToFront(countDownLabel)
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: Selector("runCountdown"), userInfo: nil, repeats: true)
    }
    
    func runCountdown () {
        countDown--
        soundHandler.playAudio(countdownAudioPlayer)
            if countDown <= 0 {
                countDown = 4
                countDownTimer.invalidate()
                viewHandler.removeViews(self)
                countDownLabel.hidden = true
                nodeHandler.showNodes([noButton, yesButton, timerLabel, augendLabel, addendLabel, operatorLabel, equalsLabel, summationLabel])
                startNewGame()
            }
        countDownLabel.text = ("\(countDown)")
    }
    
    //Timer handling
    func startNewGame () {
        stats.reset()
        scoreLabel.text = "\(stats.score)"
        timeLeft = 10
        nextSetOfNumbers()
        myTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimerLabel"), userInfo: nil, repeats: true)
    }
    
    func updateTimerLabel () {
        let rounded = round(timeLeft*10)/10
        if timeLeft <= 0 {
            gameOver()
        } else {
            timeLeft = timeLeft - 0.1
            timerLabel.text = ("\(rounded)")
        }
    }
    
    func gameOver () {
        myTimer.invalidate()
        gameOverViewController.loadStats(stats)
        viewHandler.addPopoverViewWithFade(gameOverViewController.view,viewControllerToFade: self)
    }
    
    func answer (correctAnswer: Bool) {
        if correctAnswer {
            stats.correctAnswer()
            scoreLabel.text = "\(stats.score)"
            nodeHandler.showNodes([correctLabel])
            nodeHandler.hideNodes([incorrectLabel])
            soundHandler.playAudio(successAudioPlayer)
            timeLeft = timeLeft + 1
        } else {
            stats.incorrectAnswer()
            nodeHandler.hideNodes([correctLabel])
            nodeHandler.showNodes([incorrectLabel])
            soundHandler.playAudio(failAudioPlayer)
            timeLeft = timeLeft - 5
        }
        nextSetOfNumbers()
    }
    
    func nextSetOfNumbers () {
        answerIsCorrect = gameHandler.getNextSetOfNumbers(gameTypeToLoad, augendLabel: augendLabel, addendLabel: addendLabel, answerLabel: summationLabel)
    }
    
    //Button handling
    @IBAction func userSelectedAnswer(sender: UIButton) {
        if sender.titleLabel?.text! == "Yes" {
            if answerIsCorrect! {answer(true)}
            else {answer(false)}
        }
        else {if answerIsCorrect! {answer(false)}
            else {answer(true)}
        }
    }

    func clickedRetry () {
        nodeHandler.hideNodes([correctLabel, incorrectLabel])
        viewHandler.removeViews(self)
        startCountdown()
    }
}


//End of the line...