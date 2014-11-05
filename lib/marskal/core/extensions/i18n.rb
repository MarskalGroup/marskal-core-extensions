module I18n

  #translate a single string with no plurals, take :one or only one if only one exist
  #my understanding of how rails recommends
  #have separate entries for plurals in the internationalization fies (e.g. en.yml)
  #for example
  #    contact:
  #        one: "Contact"
  #        many: "Contacts"
  # this func automatically grabs the item labeled :one
  # if :one is not available, then the first available translation will be returned
  # ex from above:
  # I18n.tnp_single('contact')  ==> returns "Contact"
  def self.tnp_single(p_token)
    l_translate =  t(p_token)
    if l_translate.is_a?(Hash)
      l_translate = l_translate[:one]||l_translate.first[1]
    end
    l_translate
  end


  #take elements from the translation file and make into an array
  #if :count is passed, it will attempt to find the plural value from the translation file
  #plural example:
  #en.yml snippet:
  # investor_statuses:
  #   client:
  #     one: "Client"
  #     many: "Clients"
  #   prospect:
  #     one: "Prospect"
  #      many: "Prospects"
  #   cold:
  #     one: "Cold"
  #     many: "Cold Names"
  #  I18n.array_it('investor_statuses', count: :many) ==>
  #         returns ==> ["Clients", "Prospects", "Cold Names"]
  #
  # Example 2: Simple no plural terms
  #    gender:
  #      male: "Male"
  #      female: "Female"
  #   I18n.array_it('gender') ==>   ["Male", "Female"]
  #
  def self.array_it(p_token, options = {})
    options.assert_valid_keys(:count)
    l_translate = options[:count] ? plural_hash_it(p_token, options) : t(p_token)

    if l_translate.is_a?(Hash)
      l_return = []
      l_translate.each do |p_key, p_val|
        l_return << p_val
      end
    else
      l_return = Array(l_translate)
    end
    l_return
  end

  #take elements from the translation file and make into an array
  def self.plural_hash_it(p_token, options = {})
    options.assert_valid_keys(:count)
    l_count = options[:count] || :one
    l_translate = t(p_token)
    if l_translate.is_a?(Hash)
      l_return = {}
      l_translate.each do |l_key, l_val|
        if l_val.is_a?(Hash)
          l_return.merge!(l_key => l_val[l_count.to_sym]||"Not Found")
       else
         l_return.merge!(l_key => l_val)
        end
      end
    else
      l_return = l_translate
    end
    l_return
  end


end