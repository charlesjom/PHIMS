class PdfGenerator
    attr_reader :object, :user_record, :type

    def initialize(object, user_record)
        @object = object
        @type = user_record.phr_type
        @user_record = user_record
    end

    def process
        Rails.logger.info("Generating PDF file...")
        file_name = "#{type}_#{DateTime.now.to_s(:number)}"
        pdf_path = "#{Rails.root}/tmp/#{file_name}.pdf"

        view = ActionView::Base.new(Rails.root.join('app/views'))
        view.class.include ApplicationHelper
        view.class.include Rails.application.routes.url_helpers
        
        pdf = WickedPdf.new.pdf_from_string(
            view.render(
                pdf: file_name,
                template: 'user_records/view.html.haml',
                layouts: 'views/layouts/pdf.html.haml',
                locals: { content: object, user_record: user_record },
                zoom: 1.0,
                header: {right: '[page] of [topage]'}
            )
        )

        File.open(pdf_path, 'wb') do |file|
            file << pdf
        end
        
        return pdf_path
    end
end