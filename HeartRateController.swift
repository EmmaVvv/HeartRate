class HeartRateController: UIViewController {

  var pulseDetector: PulseDetector!
  var filter: Filter!
  
  //MARK: - ViewController LifeCycle
   override func viewDidLoad() {
        super.viewDidLoad()
        instantiateProperties()
    }
    
  //MARK: - Custom Methods
  private func instantiateProperties() {
        filter = Filter()
        pulseDetector = PulseDetector()
    }
  
  private func startCameraCapture {
    /* ask user for camera permission, setup AVCaptureDevice.default(for: .video) object and turn the flashligh on
    also assign self as videoOutput delegate
    */
    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
  }
    
    // Convert CIImage to CGImage
    func convert(cmage:CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
  
  //MARK: - OBJC Functions
  
  @objc func update() {
        let avePeriod = pulseDetector.getAverage()
        let pulse = 60.0 / avePeriod
        //do something with pulse value
    }
}

extension HeartRateController: AVCaptureVideoDataOutputSampleBufferDelegate {
func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
     let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
     let ciImage = CIImage(cvPixelBuffer: imageBuffer)
     //here we're converting CIImage to UIImage object
     let currentImage = self.convert(cmage: ciImage)
     //here we're going to get rgb value for the current image
     guard let imageRGBValues = image.getRGBFromImage() else { return }
     //we've got rbg values and now are going to get HSV values out of them
     let values = RGBtoHSV(imageRGBValues.r, imageRGBValues.g, imageRGBValues.b)
     if (values.1 > 0.5 && values.2 > 0.5) {
     //this means we've got the corresponding frame
            validFrameCounter += 1
            let filtered = self.filter.processValue(Float(values.0))
            if self.validFrameCounter > MIN_FRAMES_FOR_FILTER_TO_SETTLE {
                let _ = self.pulseDetector.addNewValue(filtered, atTime: CACurrentMediaTime())
        }
    }
}
