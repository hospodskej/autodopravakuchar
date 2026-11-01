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

## Before going live

- **Domain.** Canonical URLs, the sitemap, `robots.txt`, link previews and the Google business data all use
  `website:` in `config/site.yml` (currently `https://adkuchar.cz`). Change it if the site runs on another address.
- **E-mail for the poptávka form.** The form sends requests to the `email:` in `config/site.yml` through SMTP.
  Set `SMTP_ADDRESS`, `SMTP_USERNAME`, `SMTP_PASSWORD` (and `SMTP_PORT` if not 587) on the server, using the
  mailbox provider's settings for info@adkuchar.cz. Then send a test request. In development the e-mails are
  saved to `tmp/mails` instead of being sent.
- **Hosting.** The form needs a running Rails server, so the site cannot be hosted as static files (e.g. GitHub Pages).
- **Prices.** The price list lives in the database. Run `bin/rails db:seed` on the server, otherwise `/cenik` is empty.
- **Google Search Console.** After launch, add the site at https://search.google.com/search-console and submit
  `https://adkuchar.cz/sitemap.xml` so Google indexes the pages and reports problems.
- **Google Business Profile.** Zdeněk sets this up himself at https://business.google.com (Google verifies the owner).
  Use exactly the same name, address and phone number as on the website.
- **Privacy policy.** Confirm the retention periods and the list of recipients (accountant, hosting provider) on
  `/zasady-ochrany-osobnich-udaju`, and update the effective date if anything changes.
