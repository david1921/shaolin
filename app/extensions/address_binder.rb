module AddressBinder

  ID_KEY = 'id'

  def mark_empty_addresses_for_deletion(hash = params, regex = /address_attributes$/)
    hash.keys.each { |k| mark_empty_address_for_deletion(k, hash) if k.match(regex) }
  end

  def mark_empty_address_for_deletion(key, hash = params)
    return unless hash.key? key
    address = hash[key].stringify_keys!
    return unless address.key?(ID_KEY) && address[ID_KEY]
    return unless hash[key].all? { |k, v| k == ID_KEY || v.blank? }
    address.merge!(_destroy: '1')
  end

  def clear_address(address)
    address.each {|k, v| address[k] = nil if k.to_s != ID_KEY } if address
  end

end