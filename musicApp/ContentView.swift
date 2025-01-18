//
//  ContentView.swift
//  musicApp
//
//  Created by Hemant Mehta on 16/01/25.
//

import SwiftUI
import AVFoundation

class AudioPlayerViewModel: ObservableObject {
    private var audioPlayer=AVAudioPlayer()
    
    func playChord(_ chord: String)
    {
        guard let path=Bundle.main.path(forResource: chord, ofType: "mp3") else {
            print("No file found for \(chord).mp3!")
            return
        }
        let url=URL(fileURLWithPath: path)
        do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
                } catch {
                    print("Error playing \(chord).mp3: \(error.localizedDescription)")
                }
    }
}

struct ContentView: View {
    
    @StateObject private var audioPlayerViewModel=AudioPlayerViewModel()
    @State private var currentChord: String = ""
    private let chords=["C","G","Am","F"]
    
    var body: some View {
        VStack {
            
            
            Text("Chord Player")
                .font(.title)
                .padding()
                .fontWeight(.bold)
                
            
            HStack(spacing: 20){
                ForEach(chords, id: \.self){
                    chord in
                    Button(action:{
                        audioPlayerViewModel.playChord(chord)
                        currentChord=chord
                    }){
                        Text(chord)
                            .font(.title)
                            .frame(width: 60, height: 60)
//                            .background(.mint)
                            .foregroundColor(.black)
//                            .cornerRadius(10)
                    }
                    .background(.mint)
                    .cornerRadius(10)
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
