let MAX_PERIODS_TO_STORE = 18
let AVERAGE_SIZE = 20
let INVALID_PULSE_PERIOD = -1

let MAX_PERIOD = 1.5
let MIN_PERIOD = 0.1
let INVALID_ENTRY = -100

class PulseDetector { 
  func addNewValue(_ newVal: Float, atTime time: Double) -> Float {
        // we keep track of the number of values above and below zero
        if newVal > 0 {
            upVals[upValIndex] = newVal
            upValIndex += 1
            if upValIndex >= AVERAGE_SIZE {
                upValIndex = 0
            }
        }
        if newVal < 0 {
            downVals[downValIndex] = -newVal
            downValIndex += 1
            if downValIndex >= AVERAGE_SIZE {
                downValIndex = 0
            }
        }
        // work out the average value above zero
        var count: Float = 0
        var total: Float = 0
        for i in 0..<AVERAGE_SIZE {
            if upVals[i] != Float(INVALID_ENTRY) {
                count += 1
                total += upVals[i]
            }
        }
        let averageUp = total / count
        // and the average value below zero
        count = 0
        total = 0
        for i in 0..<AVERAGE_SIZE {
            if downVals[i] != Float(INVALID_ENTRY) {
                count += 1
                total += downVals[i]
            }
        }
        let averageDown = total / count
        // is the new value a down value?
        if newVal < -0.5 * averageDown {
            wasDown = true
        }
        // is the new value an up value and were we previously in the down state?
        if newVal >= 0.5 * averageUp && wasDown {
            wasDown = false
            // work out the difference between now and the last time this happenned
            if time - Double(periodStart) < MAX_PERIOD && time - Double(periodStart) > MIN_PERIOD {
                periods[periodIndex] = time - Double(periodStart)
                periodTimes[periodIndex] = time
                periodIndex += 1
                if periodIndex >= MAX_PERIODS_TO_STORE {
                    periodIndex = 0
                }
            }
            // track when the transition happened
            periodStart = Float(time)
        }
        // return up or down
        if newVal < -0.5 * averageDown {
            return -1
        } else if newVal > 0.5 * averageUp {
            return 1
        }
        return 0
    }
    
    func getAverage() -> Float {
        let time = CACurrentMediaTime()
        var total: Double = 0
        var count: Double = 0
        for i in 0..<MAX_PERIODS_TO_STORE {
            // only use upto 10 seconds worth of data
            if periods[i] != Double(INVALID_ENTRY) && time - periodTimes[i] < 10 {
                count += 1
                total += periods[i]
            }
        }
        // do we have enough values?
        if count > 2 {
            return Float(total / count)
        }
        return Float(INVALID_PULSE_PERIOD)
    }
}
