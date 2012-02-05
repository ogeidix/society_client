module SocietyClient
  class Note
    include HTTParty
    base_uri 'http://beta.teamlife.it/society/services/json'

    attr_accessor :id, :isbn, :document_location, :author, :body, :related_text, :rating, :created_at
    
    def initialize(options = {})
      self.document_location = {}
      options.each { |k,v| self.send("#{k}=".to_sym,v) if self.respond_to?(k) }
    end
    
    def document_location=(location)
      @document_location =  {firstParagraph: 0, firstWord: 0, firstChar: 0, lastParagraph: 0, lastWord: 0, lastChar: 0}.merge(location)
    end
    
    def persisted?
      return (id != nil)
    end
    
    def save!
      raise "Cannot save note because already persisted" if persisted?
      return false if not valid?
      response = self.class.send_query 'textnote.save', { isbn: isbn,           is_TTS: is_TTS,
                                                    is_public: is_public, username: author,
                                                    note: body,           text: related_text }.merge(document_location)
      self.id = response['#data']
      return true
    end

    def valid?
      raise "Note invalid: missing isbn"   if isbn.to_s.empty?
      raise "Note invalid: missing body"   if body.to_s.empty?
      raise "Note invalid: missing author" if author.to_s.empty?
      return true
    end
    
    def is_TTS
      0
    end
    
    def is_public
      1
    end
    
    def self.send_query(method, content)
      response = JSON.parse(self.post('', :body => "method=#{method}&content=#{content.to_json}").parsed_response)
      raise "Remote error: #{response['#data']}" if response['#error']
      return response
    end
    
    def self.find_all(conditions)
      raise('Missing :document or :author condition') unless (conditions.include?(:document) || conditions.include?(:author))
      if  conditions.include? :document
        conditions[:isbn] = conditions[:document]
        conditions.delete(:document)
      else
        conditions[:isbn] = ''
      end
      if conditions.include? :author
        conditions[:username] = conditions[:author]
        conditions.delete(:author)
      end
      response = self.send_query('textnote.get', conditions)
      return response["#data"].map { |data|
        self.new( id:                 data['nid'],
                  isbn:               data['field_textnote_parent_isbn'][0]['value'],
                  document_location:  { firstParagraph: data['field_textnote_fparagraph'][0]['value'],
                                        firstWord: data['field_textnote_fword'][0]['value'],
                                        firstChar: data['field_textnote_fchar'][0]['value'],
                                        lastParagraph: data['field_textnote_lparagraph'][0]['value'],
                                        lastWord: data['field_textnote_lword'][0]['value'],
                                        lastChar: data['field_textnote_lchar'][0]['value'] },
                  author:             data['name'],
                  body:               data['title'],
                  related_text:       data['body'],
                  rating:             data['field_textnote_rating'][0]['value'],
                  created_at:         data['created'])
      }
    end
  end
end