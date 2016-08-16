//
//  RecodringSoundsViewController.swift
//  PitchPerfect
//
//  Created by Joshua Rogers on 8/15/16.
//  Copyright © 2016 TAJ Games. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecoder: AVAudioRecorder!

    @IBAction func recordAudio(sender: AnyObject) {
        labelButtonEnabler(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "recordingVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecoder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecoder.delegate = self
        audioRecoder.meteringEnabled = true
        audioRecoder.prepareToRecord()
        audioRecoder.record()
    }

    @IBAction func stopAudio(sender: AnyObject) {
        labelButtonEnabler(false);
        
        audioRecoder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func labelButtonEnabler(recording: Bool) {
        stopRecordingButton.enabled = recording
        recordButton.enabled = !recording
        if (recording) {
            recordingLabel.text = "Recording in Progress"
        }
        else {
            recordingLabel.text = "Tap to Record"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordingButton.enabled = false
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Recording Finished")
        if (flag) {
            performSegueWithIdentifier("stopRecording", sender: audioRecoder.url)
        }
        else {
            print("Saving of the recording failed")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

