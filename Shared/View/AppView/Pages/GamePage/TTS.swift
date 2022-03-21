import Speech
import Promises

class TTS: NSObject, AVSpeechSynthesizerDelegate {
  let synthesizer = AVSpeechSynthesizer()
  let enVoice = AVSpeechSynthesisVoice.speechVoices().filter { $0.language.contains("en") }[0]
  var promise = Promise<Void>.pending()

  func say(_ text: String) -> Promise<Void> {
    promise = Promise<Void>.pending()
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = enVoice
    synthesizer.delegate = self
    synthesizer.speak(utterance)
    return promise
  }

  func speechSynthesizer(_: AVSpeechSynthesizer,
                         didFinish utterance: AVSpeechUtterance) {
    promise.fulfill(())
  }
}
