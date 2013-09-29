ALPHABET = (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).join
URL_REGEX = /^(([^:\/?#]+):)?(\/\/([^\/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?/

module ShortedUrlHelper
  def self.encode(id)
    return nil if (id == nil)
    return ALPHABET[0] if id == 0
    shortedUrl = ''
    base = ALPHABET.length
    while id > 0
      shortedUrl << ALPHABET[id.modulo(base)]
      id /= base
    end
    shortedUrl.reverse
  end
  def self.decode(shortedUrl)
    i = 0
    base = ALPHABET.length
    shortedUrl.each_char { |c| i = i * base + ALPHABET.index(c) }
    return i
  end
end