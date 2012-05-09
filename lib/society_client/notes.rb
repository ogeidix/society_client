class SocietyClient::Notes
  def initialize(client)
    @client = client
  end
  
  def find_all_by_document_and_group(document, group_id=nil, conditions = {})
    group_id ||= @client.groups[0]['nid'] if @client.groups[0]
    response = @client.send_query('textnote.getbygroup', conditions.merge({isbn: document, groupid: group_id, username: @client.username}))
    return response.map { |data|
      self.new( id:                 data['nid'],
                isbn:               data['field_textnote_parent_isbn'][0]['value'],
                document_location:  { firstParagraph: data['field_textnote_fparagraph'][0]['value'],
                                      firstWord: data['field_textnote_fword'][0]['value'],
                                      firstChar: data['field_textnote_fchar'][0]['value'],
                                      lastParagraph: data['field_textnote_lparagraph'][0]['value'],
                                      lastWord: data['field_textnote_lword'][0]['value'],
                                      lastChar: data['field_textnote_lchar'][0]['value'] },
                username:           data['name'],
                body:               data['title'],
                related_text:       data['body'],
                rating:             data['field_textnote_rating'][0]['value'],
                created_at:         data['created'],
                rating:             data['field_textnote_rating'][0]['value'])
    }
  end
  
  
  def new(options={})
    SocietyClient::Note.new(@client, options)
  end
  
end