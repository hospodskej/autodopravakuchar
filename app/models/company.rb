module Company
  NAME = "Autodoprava Kuchař".freeze
  PHONE = "+420 739 291 053".freeze
  PHONE_URI = "tel:+420739291053".freeze
  EMAIL = "info@adkuchar.cz".freeze
  STREET = "Těšetice 39".freeze
  POSTAL_CODE = "671 61".freeze
  CITY = "Těšetice".freeze
  DISTRICT = "okres Znojmo".freeze
  MAP_URL = "https://www.google.com/maps/search/?api=1&query=#{ERB::Util.url_encode("Těšetice 39, 671 61 Těšetice")}".freeze
end
