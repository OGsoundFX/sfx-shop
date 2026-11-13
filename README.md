# BAM Sound Effects

BAM Sound Effects (BAMSFX) is an online marketplace for production-ready sound effects. Customers can discover individual sounds and curated packs, audition audio in the browser, and build custom collections to suit their projects.

**Live site:** [bamsfx.com](https://www.bamsfx.com)

## What makes the project interesting

- [**Custom Pack Builder**](https://www.bamsfx.com/pack_builder) — Search and filter the sound library, assemble a hand-picked collection, and see its tier-based price update as it grows. The builder supports both signed-in customers and guests. [Watch the Pack Builder presentation](https://bamsfx-general-content.s3.eu-central-1.amazonaws.com/pack_builder_presentation.mp4).
- **Waveform audio previews** — WaveSurfer.js renders interactive waveforms with playback controls, duration and loading feedback, and watermarked previews. Players are cleaned up across Turbo navigation.
- **Digital storefront and checkout** — Browse sound packs and individual tracks, manage a cart, and complete purchases through Stripe Checkout.
- **Sound-designer tools** — Includes designer profiles and listing management, a submission and review flow, and sales and payout dashboards.
- **Responsive Rails interface** — Server-rendered views are enhanced with Hotwire (Turbo and Stimulus), with responsive layouts for desktop and mobile.

## Technology

- Ruby 3.4 and Rails 7.1
- PostgreSQL
- Hotwire: Turbo and Stimulus
- JavaScript, esbuild, and Sass
- WaveSurfer.js for audio visualization
- Stripe for payments
- Amazon S3 and Cloudinary for media storage

## Run locally

Prerequisites: Ruby 3.4.8, Node.js 22, Yarn, and PostgreSQL.

```sh
bundle install
yarn install
bin/rails db:prepare
bin/dev
```

Configure the development credentials required by the integrations you want to use (such as Stripe and media storage) before testing those features. Keep secrets in local environment configuration; never commit them.

## Tests

```sh
bundle exec rspec
bin/rails test
```
