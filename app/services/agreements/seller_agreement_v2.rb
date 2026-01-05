module Agreements
  class SellerAgreementV2 < Base
    AGREEMENT_HTML = <<~HTML
      <h1>Testing Seller Agreement V2</h1>
    HTML

    def initialize
      super(key: "seller_agreement", version: "2_0", title: "BamSFX Seller Agreement V2", html: AGREEMENT_HTML)
    end
  end
end
