//
//  ContentView.swift
//  musicApp
//
//  Created by Hemant Mehta on 16/01/25.


import SwiftUI
import AVFoundation

class AudioPlayerViewModel: ObservableObject {
    private var audioPlayer: AVAudioPlayer?

    func playChord(_ chord: String) {
        guard let path = Bundle.main.path(forResource: chord, ofType: "mp3") else {
            print("No file found for \(chord).mp3!")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing \(chord).mp3: \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    @StateObject private var audioPlayerViewModel = AudioPlayerViewModel()
    @State private var lyrics: String = ""
    @State private var selectedChord: String = ""
    @State private var isPlaying: Bool = false
    @State private var wordIndex: Int = 0
    private let chords = ["C", "G", "Am", "F"]
    private var words: [String] { lyrics.components(separatedBy: " ") }
    
    var body: some View {
        VStack {
            Text("Song Player")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Lyrics Input
            VStack(alignment: .leading) {
                Text("Enter Song Lyrics:")
                    .font(.headline)
                TextEditor(text: $lyrics)
                    .frame(minHeight: 100)
                    .border(Color.gray, width: 1)
                    .cornerRadius(8)
                    .padding(.bottom)
            }
            .padding()

            // Chord Selection
            VStack(alignment: .leading) {
                Text("Select a Chord:")
                    .font(.headline)
                HStack(spacing: 20) {
                    ForEach(chords, id: \.self) { chord in
                        Button(action: {
                            selectedChord = chord
                        }) {
                            Text(chord)
                                .font(.title2)
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                                .background(selectedChord == chord ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()

            // Play Button
            Button(action: {
                if !selectedChord.isEmpty && !lyrics.isEmpty {
                    startPlayingSong()
                } else {
                    print("Please enter lyrics and select a chord!")
                }
            }) {
                Text(isPlaying ? "Playing..." : "Play")
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(isPlaying ? Color.gray : Color.green)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(isPlaying)

            // Display Current State
            Text("Selected Chord: \(selectedChord.isEmpty ? "None" : selectedChord)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top)
        }
        .padding()
    }

    func startPlayingSong() {
        isPlaying = true
        wordIndex = 0
        
        playNextWord()
    }
    
    func playNextWord() {
        if wordIndex < words.count {
            // Play the chord for the current word
            audioPlayerViewModel.playChord(selectedChord)
            
            // Move to the next word after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                wordIndex += 1
                playNextWord()
            }
        } else {
            // Stop playback when finished
            isPlaying = false
            print("Finished playing the song!")
        }
    }
}


#Preview {
    ContentView()
}
