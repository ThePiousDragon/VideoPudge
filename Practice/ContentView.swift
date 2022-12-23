import SwiftUI

struct ContentView: View {
    @State private var startTime: String = ""
    @State private var endTime: String = ""
    @State private var inputFilename: String = ""
    
    @State private var preciseSeek: Bool = false
    
    let videoCodecs = ["libx265", "h264", "vp8", "vp9", "Copy from source", "No video"]
    let audioCodecs = ["mp3", "aac", "Copy from source", "No audio"]
    @State private var videoCodec: String = "Copy from source"
    @State private var audioCodec: String = "Copy from source"
    
    @State private var outputFilename: String = ""
    
    @State private var finalCommand: String = ""
    var body: some View {
        
        GroupBox(label: Text("Input information")) {
            TextField("Input filename", text: $inputFilename)
                .padding()
            HStack {
                TextField("Start time", text :$startTime)
                TextField("End time", text: $endTime)
            }
            .padding()
            Toggle(isOn: $preciseSeek) {
                Label("Precise seek", systemImage: "arrowshape.bounce.right")
            }
        }
        GroupBox(label: Text("Output information")) {
        VStack {
            Picker(selection: $videoCodec, label: Text("Video codec")) {
                ForEach(videoCodecs, id: \.self) {
                    Text($0)
                }
            }
            .padding()
            Picker(selection: $audioCodec, label: Text("Audio codec")) {
                ForEach(audioCodecs, id: \.self) {
                    Text($0)
                }
            }
            .padding()
            TextField("Output filename", text: $outputFilename)
                .padding()
        }
        }
        Button("Convert") {
            generateCommand(filename: inputFilename, startTime: startTime, endTime: endTime, preciseSeek: preciseSeek, videoCodec: &videoCodec, audioCodec: &audioCodec, outputFile: outputFilename)
    }
        .padding()
}
}
