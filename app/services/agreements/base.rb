module Agreements
  class Base
    def initialize(infos = {key: "template_agreement", version: "0_0", title: "template title", html: "<h1>template</h1>"})
      @key = infos[:key]
      @version = infos[:version]
      @title = infos[:title]
      @html = infos[:html]
    end

    def create_agreement!
      agreement = Agreement.find_or_initialize_by(key: @key, version: @version)
      agreement.title = @title
      agreement.active = true
      agreement.published_at ||= Date.today
      agreement.body = @html
      agreement.save!
      create_pdf(agreement)
    end

    def update_agreement!
      agreement = Agreement.find_by(key: @key, version: @version)
      return unless agreement

      agreement.body = @html
      agreement.save!
      create_pdf(agreement)
    end

    def generate_seller_agreement(designer, request)
      agreement = Agreement.find_by(key: @key, version: @version)
      return unless agreement

      accepted_at = Time.current.strftime("%B %d, %Y")
      ip_address = request.remote_ip || "N/A"
      legal_name = designer.user.legal_entity.present? ? designer.user.legal_entity.legal_name : "#{designer.user.first_name} #{designer.user.last_name}"

      agreement.body = @html
        .gsub("{{legal_name}}", legal_name)
        .gsub("{{artist_name}}", designer.artist_name)
        .gsub("{{accepted_at}}", accepted_at)

      agreement
    end

    private

    def create_pdf(agreement)
      html = <<~HTML
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="UTF-8">
          </head>
          <body>
            <style>
              body {
                font-family: Helvetica, Arial, sans-serif;
                font-size: 16px;
                line-height: 1.6;
              }

              h1, h2, h3, h4, h5, h6 {
                page-break-after: avoid;
              }
            </style>
            #{@html.gsub(/&nbsp\s*(?:•|-)\s*/, "")}
          </body>
        </html>
      HTML

      pdf = WickedPdf.new.pdf_from_string(
        html,
        page_size: "A4",
        margin: { top: 15, bottom: 15, left: 20, right: 20 },
        encoding: "UTF-8"
      )

      agreement.pdf.attach(
        io: StringIO.new(pdf),
        filename: "#{agreement.key}_version_#{agreement.version}.pdf",
        content_type: "application/pdf"
      )
    end
  end
end
