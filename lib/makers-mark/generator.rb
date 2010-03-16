module MakersMark
  class Generator
    def initialize(markdown)
      @markdown = markdown
    end

    def to_html
      highlight!
      doc.search('body > *').to_html
    end

    private

    def doc
      @doc ||= Nokogiri::HTML(markup)
    end

    def highlight!
      doc.search('div.code').each do |div|
        lexer = div['rel'] || :ruby

        lexted_text = Albino.new(div.text, lexer).to_s

        highlighted = Nokogiri::HTML(lexted_text).at('div')

        klasses = highlighted['class'].split(/\s+/)
        klasses << lexer
        klasses << 'code'
        klasses << 'highlight'
        highlighted['class'] = klasses.join(' ')

        div.replace(highlighted)
      end
    end

    def markup
      @markup ||= begin
        logger.info "WRITING!"
        text = @markdown.dup
        ### NOTE: preserve code snippets
        text.gsub!(/^(?:<p>)?@@@(?:<\/p>)?$/, '</div>')
        text.gsub!(/^(?:<p>)?@@@\s*([\w\+]+)(?:<\/p>)?$/, '<div class="code" rel="\1">')
        ### NOTE: convert to html and return
        BlueCloth.new(text).to_html
      end
    end

    def logger
      @logger ||= Class.new {
        def info(msg)
          say msg
        end

        private

        def say(msg)
          $stdout.puts msg if $VERBOSE
        end
      }.new
    end
  end
end
