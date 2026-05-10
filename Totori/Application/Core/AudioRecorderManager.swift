//
//  AudioRecorderManager.swift
//  Totori
//
//  Created by 정윤아 on 5/3/26.
//

import AVFoundation
import Foundation

class AudioRecorderManager: NSObject {
    private var audioRecorder: AVAudioRecorder?
    private var currentAudioURL: URL?
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *){
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async{
                    completion(granted)
                }
            }
        }
    }
        
        func startRecoding() {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
                try session.setActive(true)
                
                let tempDirectory = FileManager.default.temporaryDirectory
                let filename = "totori_record_\(Int(Date().timeIntervalSince1970)).m4a"
                let audioFileURL = tempDirectory.appendingPathComponent(filename)
                self.currentAudioURL = audioFileURL
                
                let settings: [String: Any] = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
                audioRecorder?.record()
                print("🎙️ 오디오 녹음 시작: \(audioFileURL.lastPathComponent)")
            } catch {
                print("❌ 녹음 시작 실패: \(error.localizedDescription)")
            }
        }
        
    func stopRecording() -> URL? {
        audioRecorder?.stop()
        audioRecorder = nil
        
        if let url = currentAudioURL {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
                let fileSize = attributes[.size] as? Int64 ?? 0
                print("🛑 오디오 녹음 완료")
                print("   📁 경로: \(url.path)")
                print("   📦 크기: \(ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file))")
            } catch {
                print("🛑 오디오 녹음 완료 (크기 확인 실패: \(error))")
            }
        }
        
        return currentAudioURL
    }
        
    }
