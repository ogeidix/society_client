class SocietyClient::Note
    attr_accessor :id, :isbn, :document_location, :username, :body, :related_text,
                  :rating, :created_at, :is_TTS, :is_public, :ranking
    
    def initialize(client, options = {})
      @client = client
      self.is_TTS = 0
      self.is_public = 1      
      self.document_location = {}
      self.username = @client.username
      options.each { |k,v| self.send("#{k}=".to_sym,v) if self.respond_to?(k) }
    end
    
    def as_json(options={})
      { id: id, isbn: isbn, document_location: document_location, username: username,
        body: body, related_text: related_text, rating: rating, created_at: created_at,
        is_TTS: is_TTS, ranking: ranking }
    end
   
    def save!
      raise "Cannot save note because already persisted" if persisted?
      return false if not valid?
      self.id = @client.send_query 'textnote.save', { isbn: isbn,         is_TTS: is_TTS, is_public: is_public,
                                                      username: username, note: body,     text: related_text }.merge(document_location)
      return true
    end
   
    # def destroy!
    #   @client.send_query 'texnote.delete', {nid: id}
    #   return true
    # end
    
    def document_location=(location)
      @document_location =  {firstParagraph: 0, firstWord: 0, firstChar: 0, lastParagraph: 0, lastWord: 0, lastChar: 0}.merge(location)
    end
    
    def persisted?
      return (id != nil)
    end

    def valid?
      raise "Note invalid: missing isbn"   if isbn.to_s.empty?
      raise "Note invalid: missing body"   if body.to_s.empty?
      raise "Note invalid: missing username" if username.to_s.empty?
      return true
    end
end