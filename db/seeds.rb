# Price list items shown on /cenik. Safe to run repeatedly: `bin/rails db:seed`.
# Leave `price` empty for items priced individually ("dle dohody").
[
  { category: "Palivové dřevo", name: "Tvrdé palivové dřevo", unit: "metr sypaný", price: 1250, position: 1 },
  { category: "Práce bagrem", name: "Zemní práce bagrem 3,5 t", price: nil, position: 1 }
].each do |attrs|
  PriceItem.find_or_initialize_by(category: attrs[:category], name: attrs[:name]).update!(attrs)
end
