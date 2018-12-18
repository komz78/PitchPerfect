//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Komil Bagshi on 28/10/2018.
//  Copyright © 2018 KamelBaqshi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate{
    
    var audioRecorder: AVAudioRecorder!
    
    //** Outlets:
    @IBOutlet var recordLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopRecrodingButton: UIButton!
    
    
    // vars - lets
    
    let stopRecordingSegue = "stopRecording"
    
    //** View Did Load
    //start app
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopRecrodingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //** View Will Appear
    //after launching
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear called.")
        //code
    }

    
    // MARK: UI Functions
    enum recordingState { case recording, notRecording }
    
    //**** TODO: Fix the function
    func configureUIButton(_ RecordingState: recordingState) {
        //the reviewer "Francisco" helped with this shorter code, thanks to him.
        let isRecording = RecordingState == .recording
        setRecordingButtonsEnabled(!isRecording)
        stopRecrodingButton.isEnabled = isRecording
        recordLabel.text = isRecording ? "stop recording..." : "tap to record..."
    }
    
    func setRecordingButtonsEnabled(_ enabled: Bool) {
        recordButton.isEnabled = enabled
    }
    
    // MARK: ACTIONS --> the wired button action.

    @IBAction func recordAudio(_ sender: Any) {
        configureUIButton(.recording)
        
        //path directiory
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        //name of recording
        let recordingName = "recordedVoice.wav"
        //to join path array with saperator
        let pathArray = [dirPath, recordingName]
        //assigning the path of url type
        let filePath = URL(string: pathArray.joined(separator: "/"))
        //starting a new session
        let session = AVAudioSession.sharedInstance()
        //the session category and setting up the av recorder delegates.
        try! session.setCategory(.playAndRecord, mode: .default)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordingAudio(_ sender: Any) {
        configureUIButton(.notRecording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // delegate for AvAudioRecorder
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("stopped recording.")
            performSegue(withIdentifier: stopRecordingSegue, sender: audioRecorder.url)
        } else {
            print("error recording.")
        }
    }
    
    // moving to another VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == stopRecordingSegue {
            let PlaySoundsVC = segue.destination as! PlaySoundsViewController
            let recrodedAudioURL = sender as! URL
            PlaySoundsVC.recordingAudioURL = recrodedAudioURL
        }
    }
}

