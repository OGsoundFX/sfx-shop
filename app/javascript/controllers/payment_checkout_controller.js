import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { publishableKey: String, sessionId: String }

  redirect() {
    if (!window.Stripe) {
      console.error("Stripe.js is not available")
      return
    }

    const stripe = window.Stripe(this.publishableKeyValue)
    stripe.redirectToCheckout({ sessionId: this.sessionIdValue }).then(
      ({ error }) => {
        if (error) console.error("Could not redirect to Stripe Checkout:", error)
      },
      (error) => console.error("Could not start Stripe Checkout:", error)
    )
  }
}
