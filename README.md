# Autodoprava Kuchař

Ruby on Rails rewrite of [adkuchar.cz](https://adkuchar.cz): home page, services, equipment gallery, price list (Ceník) and contacts.

## Design

Colours come from the fleet: MAN cab green `#2c6736`, tipper-body blue `#17427a` and the red/white
bumper warning stripes, on warm paper `#f6f3ec`. Type is Barlow Condensed (headings) and Barlow (body),
self-hosted from `app/assets/fonts` (SIL OFL) so no third-party font requests are made.

Photos are in `app/assets/images/technika` (originals) and `technika/nahled` (800px thumbnails);
captions/alt texts live in `config/gallery.yml`. Contact details are in `app/models/company.rb`.

## Setup

```sh
bundle install
bin/rails db:prepare
bin/rails server   # http://localhost:3000
bin/rails test
```

## Price list

Prices are stored in the `price_items` table (`category`, `name`, `unit`, `price`, `note`, `position`)
and grouped by category on `/cenik`. An empty `price` renders as "dle dohody".
While the table is empty the page shows a prompt to get in touch. See `db/seeds.rb` for an example.
