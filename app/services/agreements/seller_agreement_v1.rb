module Agreements
  class SellerAgreementV1 < Base
    AGREEMENT_HTML = <<~HTML
      <h1>BamSFX Seller Agreement</h1>
      <h5>Version 1.0 - Effective Date: December 1, 2025</h5>
      <br>
      <p>
        This Seller Agreement (the <strong>“Agreement”</strong>) is entered into between
        <strong>BamSFX.com</strong> (the <strong>“Platform”</strong>, <strong>“BamSFX”</strong>, <strong>“we”</strong>, or <strong>“us”</strong>)
        and <strong>{{legal_name}}</strong>, operating under the artist name
        <strong>{{artist_name}}</strong> (the <strong>“Seller”</strong>, <strong>“you”</strong>, or <strong>“your”</strong>), {{address}}.
      </p>

      <p>
        By accepting this Agreement, Seller agrees to be bound by the terms and conditions set forth below.
      </p>

      <br>
      <hr>

      <h2>1. Definitions</h2>

      <ul>
        <li>&nbsp &nbsp• <strong>“Platform”</strong>: The online marketplace operated at <strong>BamSFX.com</strong>.</li>
        <li>&nbsp &nbsp• <strong>“Seller”</strong>: The individual or legal entity providing sound effects for sale.</li>
        <li>&nbsp &nbsp• <strong>“Content”</strong>: digital sound effect packages (“SFX packs”) uploaded by Seller, including audio files, metadata, descriptions, and cover images.</li>
        <li>&nbsp &nbsp• <strong>“Customers”</strong>: End users purchasing Content via the Platform.</li>
        <li>&nbsp &nbsp• <strong>“Net Revenue”</strong>: Gross sales amount minus applicable taxes (including VAT), payment processing fees, currency conversion fees, refunds, chargebacks, and discounts.</li>
      </ul>

      <br>
      <br>
      <h2>2. Seller Eligibility</h2>

      <p>The Seller represents and warrants that:</p>
      <ul>
        <li>&nbsp &nbsp• The Seller is at least 18 years old;</li>
        <li>&nbsp &nbsp• The Seller has full legal capacity to enter into this Agreement as an individual or as a legally registered business entity;</li>
        <li>&nbsp &nbsp• Seller has provided accurate, complete, and up-to-date legal, tax, and payment information;</li>
      </ul>

      <br>
      <br>
      <h2>3. Content Submission Rules</h2>

      <ul>
        <li>&nbsp &nbsp• All Content submissions are subject to review and approval by BamSFX;</li>
        <li>&nbsp &nbsp• BamSFX reserves the right to reject, remove, or disable any Content at its sole discretion;</li>
        <li>&nbsp &nbsp• Content must meet the Platform’s quality, technical, and editorial standards;</li>
        <li>&nbsp &nbsp• Seller agrees not to upload Content that is unlawful, infringing, misleading, defamatory, offensive, or otherwise harmful;</li>
        <li>&nbsp &nbsp• BamSFX may remove Content or suspend Seller accounts immediately in case of suspected violations.</li>
        <li>&nbsp &nbsp•
          The Seller represents and warrants that all submitted Content is
          <strong>entirely original, human-created sound design</strong> and that
          <strong>no part of the Content has been generated, synthesized, trained, enhanced,
          transformed, or derived from artificial intelligence, machine learning models,
          or automated content generation tools</strong>, whether in whole or in part.
        </li>

        <li>&nbsp &nbsp•
          The Seller further warrants that no artificial intelligence tools were used at any
          stage of the creative process, including but not limited to sound generation,
          dataset training, style transfer, reconstruction, upscaling, or automated editing.
        </li>

        <li>&nbsp &nbsp• 
          Any breach of this warranty constitutes a <strong>material violation</strong> of this
          Agreement and may result in immediate removal of the affected Content, suspension
          or termination of the Seller’s account, forfeiture of unpaid balances, and any other
          remedies available to BamSFX under applicable law.
        </li>
      </ul>
      <br>
      <br>
      <h2>4. Rights &amp; Ownership</h2>
      <ul>
        <li>&nbsp &nbsp• The Seller retains full ownership of all intellectual property rights in the Content, subject to the license granted to BamSFX under this Agreement.</li>
        <li>&nbsp &nbsp• Customers receive only a non-exclusive license to use the Content as defined by BamSFX’s end-user license terms.</li>
      </ul>

      <br>
      <br>
      <h2>5. Seller Warranties</h2>

      <p>The Seller expressly represents and warrants that:</p>

      <ul>
        <li>&nbsp &nbsp• The Seller is the sole and exclusive owner of all rights included in the Content;</li>
        <li>&nbsp &nbsp• The Content is original or properly licensed;</li>
        <li>&nbsp &nbsp• No Content infringes any copyright, trademark, moral right, or other intellectual property right;</li>
        <li>&nbsp &nbsp• The Content is not subject to any exclusive agreement that conflicts with this Agreement;</li>
        <li>&nbsp &nbsp• The Seller has full rights to use all audio files, samples, recordings, and cover images;</li>
        <li>&nbsp &nbsp• No Content contains unlawful, defamatory, or misleading material.</li>
      </ul>

      <br>
      <br>
      <h2>6. License Granted to BamSFX</h2>
      <p>The Seller hereby grants to BamSFX a worldwide, non-exclusive, royalty-free license to:</p>
      <ul>
        <li>&nbsp &nbsp• host,
          reproduce, distribute, market, promote, and sell the Content through the Platform
          for the duration of this Agreement;
        </li>
        <li>&nbsp &nbsp• display Seller’s legal name, artist name, Content previews, and associated branding for promotional purposes.</li>
      </ul>
      <br>
      <br>
      <h2>7. Payment &amp; Commission</h2>
      <br>
      <h4>7.1 Commission</h4>
      <ul>
        <li>&nbsp &nbsp• BamSFX retains <strong>30%</strong> of the Net Revenue from each sale made through the Platform.</li>
        <li>&nbsp &nbsp• The Seller receives the remaining <strong>70%</strong> of the Net Revenue.</li>
      </ul>

      <br>
      <h4>7.2 Pricing &amp; Currency</h4>

      <ul>
        <li>&nbsp &nbsp• The Seller selects a preferred payout currency: <strong>EUR</strong> or <strong>USD</strong>.</li>
        <li>&nbsp &nbsp• The Seller defines the prices of SFX packs in the selected currency.</li>
        <li>&nbsp &nbsp• Prices are displayed as follows:
          <ul>
            <li>&nbsp &nbsp &nbsp &nbsp- In <strong>EUR</strong> for Customers located within the Eurozone;</li>
            <li>&nbsp &nbsp &nbsp &nbsp- In <strong>USD</strong> for Customers located outside the Eurozone.</li>
          </ul>
        </li>
      </ul>

      <br>
      <h4>7.3 Discounts &amp; Promotions</h4>
      <ul>
        <li>&nbsp &nbsp• The Seller agrees to participate in site-wide sales, discounts, and promotional campaigns
          defined by BamSFX.</li>

        <li>&nbsp &nbsp• When a Customer purchases more than one SFX pack in a single transaction:</li>
        <ul>
          <li>&nbsp &nbsp &nbsp &nbsp- The second SFX pack and each subsequent pack receive a <strong>20%</strong> discount.</li>
        </ul>
      </ul>

      <br>
      <h4>7.4 Example Payout Calculation</h4>

      <p>
        The following example is provided for illustrative purposes only:
      </p>

      <ul>
        <li>&nbsp &nbsp• Example sale price: <strong>€50.00</strong></li>
        <li>&nbsp &nbsp• VAT (19%, collected and remitted by BamSFX): <strong>€7.98</strong></li>
        <li>&nbsp &nbsp• Net after VAT: <strong>€42.02</strong></li>
        <li>&nbsp &nbsp• Stripe processing and currency conversion fees (example): <strong>€2.00</strong></li>
        <li>&nbsp &nbsp• Net Revenue: <strong>€40.02</strong></li>
        <li>&nbsp &nbsp• BamSFX commission (30%): <strong>€12.01</strong></li>
        <li>&nbsp &nbsp• Seller share (70%): <strong>€28.01</strong></li>
      </ul>

      <br>
      <p>
        Additional PayPal payout fees may apply and are borne by the Seller.
      </p>

      <br>
      <h4>7.5 Payouts</h4>

      <ul>
        <li>&nbsp &nbsp• Payouts are processed on a monthly basis;</li>
        <li>&nbsp &nbsp• Payouts are made only if the Seller’s balance reaches at least <strong>€50</strong> or <strong>$50</strong>;</li>
        <li>&nbsp &nbsp• Payments are made via <strong>PayPal</strong>;</li>
        <li>&nbsp &nbsp• PayPal may apply additional fees, which are borne by the Seller;</li>
        <li>&nbsp &nbsp• Payouts are made in the Seller’s selected currency (EUR or USD).</li>
      </ul>

      <br>
      <br>
      <h2>8. Taxes &amp; VAT Handling</h2>
      <ul>
        <li>
          &nbsp &nbsp• BamSFX acts as the <strong>merchant of record</strong> and <strong>deemed supplier</strong>
          for VAT purposes on all sales of digital content made through the Platform.
        </li>

        <li>
            &nbsp &nbsp• The Seller sets the retail prices for their Content. All prices defined by the Seller
            are <strong>VAT-inclusive consumer prices</strong>, meaning that applicable VAT is included
            in the price displayed to Customers.
        </li>

        <li>
          &nbsp &nbsp• BamSFX is solely responsible for calculating, collecting, and remitting any applicable
          value-added tax (VAT) or similar indirect taxes to the relevant tax authorities.
        </li>

        <li>
          &nbsp &nbsp• Seller payouts are calculated on a <strong>net-of-VAT</strong> basis.
        </li>

        <li>
          &nbsp &nbsp• The Seller shall not charge, collect, or declare VAT in relation to sales made through the Platform.
        </li>

        <li>
          &nbsp &nbsp• The Seller remains solely responsible for declaring and paying any applicable
          income taxes, social contributions, or similar obligations arising from amounts
          received from BamSFX.
        </li>
      </ul>

      <br>
      <br>
      <h2>9. Currency, Pricing &amp; Promotions</h2>

      <ul>
        <li>&nbsp &nbsp• Sellers may choose EUR or USD as their preferred payout currency;</li>
        <li>&nbsp &nbsp• Prices are displayed in EUR within the Eurozone and USD elsewhere;</li>
        <li>&nbsp &nbsp• Customers purchasing more than one pack receive a 20% discount on the second and subsequent packs;</li>
        <li>&nbsp &nbsp• Sellers agree to participate in site-wide promotions and sales defined by BamSFX.</li>
      </ul>

      <br>
      <br>
      <h2>10. Payments</h2>

      <ul>
        <li>&nbsp &nbsp• Payouts are processed monthly;</li>
        <li>&nbsp &nbsp• Minimum payout threshold is €50 or $50;</li>
        <li>&nbsp &nbsp• Payments are made via PayPal;</li>
        <li>&nbsp &nbsp• PayPal fees may apply and are borne by the Seller.</li>
      </ul>

      <br>
      <br>
      <h2>11. Content Removal &amp; Termination</h2>

      <p>
        BamSFX reserves the right to immediately remove Content or terminate Seller accounts
        without prior notice in case of:
      </p>

      <ul>
        <li>&nbsp &nbsp• Violation of this Agreement;</li>
        <li>&nbsp &nbsp• Infringement of third-party rights;</li>
        <li>&nbsp &nbsp• Unlawful, defamatory, or harmful Content;</li>
      </ul>
      <p>
        Seller may request removal of Content, subject to reasonable processing time.
      </p>

      <p>
        Termination does not affect outstanding payment obligations.
      </p>

      <br>
      <br>
      <h2>12. Indemnification &amp; Liability</h2>

      <p>
        The Seller agrees to indemnify and hold harmless BamSFX against any claims,
        damages, losses, or expenses arising from a breach of this Agreement
        or intellectual property infringement of third-party rights, or unlawful content.
      </p>
      <p>
        BamSFX shall not be liable for indirect, incidental, or consequential damages.
      </p>

      <br>
      <br>
      <h2>13. Governing Law &amp; Jurisdiction</h2>

      <p>
        This Agreement shall be governed by and construed in accordance with the laws
        of the jurisdiction in which BamSFX is established (Berlin, Germany).
        The courts of that jurisdiction shall have exclusive competence.
      </p>

      <br>
      <br>
      <h2>14. Acceptance</h2>

      <p>
        By accepting this Agreement, the Seller acknowledges that they have read,
        understood, and agreed to be bound by its terms and conditions.
      </p>

      <p>
        <strong>Accepted by:</strong> {{legal_name}}<br>
        <strong>Artist Name:</strong> {{artist_name}}<br>
        <strong>Address:</strong> {{address}}<br>
        <strong>Date:</strong> {{accepted_at}}<br>
      </p>
    HTML

    def initialize
      super(key: "seller_agreement", version: "1_0", title: "BamSFX Seller Agreement", html: AGREEMENT_HTML)
    end
  end
end
