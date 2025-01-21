import Foundation
import Capacitor
import StoreKit

@objc public class InAppReview: NSObject {
    @objc func requestReview(_ call: CAPPluginCall) {
        if #available(iOS 17.0, *) {
            @Environment(\.requestReview) private var requestReview

            private func presentReview() {
                Task {
                    // Delay for two seconds to avoid interrupting the person using the app.
                    try await Task.sleep(for: .seconds(2))
                    await requestReview()
                }
            }
            
            presentReview()

            /*
            if processCompletedCount >= 4, currentAppVersion != lastVersionPromptedForReview {
                    
                // The app already displayed the rating and review request view. Store this current version.
                lastVersionPromptedForReview = currentAppVersion
            }

            var body: some View {
                Button("Ask for Review") {
                    DispatchQueue.main.async {
                        requestReview()
                    }
                }
            }
             */
        }
        else if #available(iOS 14.0, *) {
             if let windowScene = UIApplication.shared.connectedScenes.first(
                where: { $0.activationState == .foregroundActive }
             ) as? UIWindowScene {
                 SKStoreReviewController.requestReview(in: windowScene)
             }
         } else {
             SKStoreReviewController.requestReview()
         }
        call.resolve()
    }
}
