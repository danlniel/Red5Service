//
//  Red5Service.swift
//  Presentr
//
//  Created by Node8 on 4/3/17.
//  Copyright © 2017 Lususlab. All rights reserved.
//

import UIKit
import R5Streaming

class Red5Service: R5VideoViewController {
  var stream: R5Stream!
  var config: R5Configuration!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    Timer.runThisAfterDelay(seconds: 10) {
      self.start()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    preview()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    stop()
  }
  
  func setup() {
    config = R5Configuration()
    config.host = "localhost"
    config.port = 8081
    config.contextName = "live"
    config.licenseKey = "D65T-7MI5-3H5J-BKIH"
  }
  
  func preview() {
    let cameraDevice: AVCaptureDevice = true ? AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).first as! AVCaptureDevice : AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).last as! AVCaptureDevice
    let camera = R5Camera(device: cameraDevice, andBitRate: 512)
    
    let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    let microphone = R5Microphone(device: audioDevice)
    
    let connection = R5Connection(config: config)
    stream = R5Stream(connection: connection)
    stream.attachVideo(camera)
    stream.attachAudio(microphone)
    stream.delegate = self
    self.attach(stream)
    self.showPreview(true)
  }
  
  func start() {
    self.showPreview(false)
    stream.publish("puki", type: R5RecordTypeLive)
  }
  
  func stop() {
    stream.stop()
    stream.delegate = nil
    self.preview()
  }
}

extension Red5Service: R5StreamDelegate {
  func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
    debugPrint("Stream: \(r5_string_for_status(statusCode)) - \(msg!)")
  }
}
