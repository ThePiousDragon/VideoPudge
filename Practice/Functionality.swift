import Foundation

func generateCommand(filename: String,
                     startTime: String,
                     endTime: String,
                     preciseSeek: Bool,
                     videoCodec: inout String,
                     audioCodec: inout String,
                     outputFile: String) {
    let duration = timeDelta(start: startTime, end: endTime)
    
    switch videoCodec {
    case "No video":
        videoCodec = "-vn"
    case "Copy from source":
        videoCodec = "copy"
    default:
        break
    }
        
    switch audioCodec {
    case "No audio":
        audioCodec = "-an"
    case "Copy from source":
        audioCodec = "copy"
    default:
        audioCodec = "\(audioCodec)"
    }
    
    let ffmpegPath = "/usr/local/bin/ffmpeg"
    var arguments = ["-ss", startTime, "-i", filename, "-t", duration, "-c:v", videoCodec, "-c:a", audioCodec, outputFile]

    if audioCodec == "-an" {
        arguments.remove(at: 8)
    }
    
    switch preciseSeek {
    case true:
        arguments.swapAt(0, 2)
        arguments.swapAt(1, 3)
    case false:
        break
    }

    let process = Process()
    process.executableURL = URL(fileURLWithPath: ffmpegPath)
    process.arguments = arguments
    
    print(arguments)

    do {
        try process.run()
        process.waitUntilExit()
    } catch {
        print("Failed to execute ffmpeg: \(error)")
    }
}

func timeDelta(start: String, end: String) -> String {
    // Convert the start and end timestamps to NSDate objects
    let dateFormatter = DateFormatter()
    if start.count < 11 {
        dateFormatter.dateFormat = "mm:ss.SSS"
    } else {
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
    }
    let startDate = dateFormatter.date(from: start)
    let endDate = dateFormatter.date(from: end)

    let timeDelta = endDate?.timeIntervalSince(startDate!)
    let outputDelta = String(format: "%.3f", timeDelta!)
    return(outputDelta)
}
