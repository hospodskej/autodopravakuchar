# Autodoprava Kuchař

Ruby on Rails rewrite of [adkuchar.cz](https://adkuchar.cz): home page, services, equipment gallery,
price list (Ceník) and contacts.

## Setup

```sh
bundle install
bin/rails db:prepare
bin/rails server   # http://localhost:3000
bin/rails test
```

## Where things live

All site content is in **`config/site.yml`** (loaded as `Rails.configuration.x.site`), restart the server after editing:

| Section    | Drives                                                                 |
|------------|------------------------------------------------------------------------|
| `company`  | Name, owner, IČO, phone, email, address – header, footer, contact page |
| `pages`    | Routes, header/footer navigation, page titles and intros               |
| `services` | Service cards on the home page and the services page                   |
| `gallery`  | Vehicle categories and their photos (`featured` ones appear on home)   |

Each entry is a small read-only `Data` model (`Company`, `SitePage`, `Service`, `GalleryCategory`,
`GalleryPhoto`) built through `SiteContent`. Adding a page = one entry in `pages` + `app/views/pages/<key>.html.erb`;
`PagesController` only defines actions for pages that load data.

Prices are the only database content: the `price_items` table (`category`, `name`, `unit`, `price`, `note`,
`position`), grouped by category on `/cenik`. An empty `price` renders as "dle dohody". See `db/seeds.rb`.

## Design

Colours come from the fleet: MAN cab green `#2c6736`, tipper-body blue `#17427a` and the red/white bumper
warning stripes, on warm paper `#f6f3ec`. Type is Barlow Condensed (headings) and Barlow (body), self-hosted
from `app/assets/fonts` (SIL OFL), one file per weight.

Photos are WebP in `app/assets/images/technika` (full size, used by the lightbox) and `technika/nahled`
(800px thumbnails). The lightbox (`app/assets/javascripts/lightbox.js`) is a native `<dialog>`; without
JavaScript the links open the full-size photo.
