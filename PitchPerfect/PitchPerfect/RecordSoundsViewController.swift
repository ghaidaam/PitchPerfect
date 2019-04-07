//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Ghaida Almahmoud on 10/07/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate{
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print ("viewWillWppear called")
    }

    func configureUI(isRecording: Bool) {
        stopRecordingButton.isEnabled = isRecording // to disable the button
        recordButton.isEnabled = !isRecording // to enable the button
        
        func configureUI(isRecording: Bool) {
            stopRecordingButton.isEnabled = isRecording // to disable the button
            recordButton.isEnabled = !isRecording // to enable the button
            recordingLabel.text = !isRecording ? "Tap to Record" : "Recording in Progress"
            
        }
        
        recordingLabel.text = !isRecording ? "Tap to Record" : "Recording in Progress"
        
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled =  false
        
        
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        configureUI(isRecording: true)
        
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
        
        
    
    @IBAction func stopRecording(_ sender: Any) {
        recordButton.isEnabled =  true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to Record"
        configureUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession . sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var _: String?
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! playSoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}
