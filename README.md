# Autodoprava Kuchař

Ruby on Rails rewrite of [adkuchar.cz](https://adkuchar.cz): price list (Ceník), contacts, services and equipment gallery.

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
