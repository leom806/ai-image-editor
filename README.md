![Logo](https://github.com/leom806/ai-image-editor/assets/7718776/9b6f619a-3c6f-4912-8dae-e54964715425)

## AI Image Editor

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/leom806/ai-image-editor/blob/main/LICENSE.txt)
[![coverage](https://github.com/leom806/ai-image-editor/blob/main/server/coverage/coverage.svg)](https://github.com/leom806/ai-image-editor/blob/main/server/coverage/)

Hey, it's nice to see you here!

This project is currently a simple image editor that uses external AI to add special powers to it.

Currently AI providers:
  - OpenAI DALL-E
  - Stability

**Midjourney will be added as soon as they provide a public API**

I'm also the author of [Midjourney Ruby](https://github.com/leom806/midjourney-ruby), a Ruby wrapper for the Midjourney service that I'll turn into a wrapper for their API once it's there.

You can find me at [LinkedIn](https://linkedin.com/in/leonardomomente) and [Twitter/X](https://twitter.com/Leo_Chromo).

#### Tech Stack

The frontend is built with Vue.js and TailwindCSS.
The backend is built with Rails and PostgreSQL.

It's not hosted anywhere yet, but you can run it locally.

#### Running locally

Personally I enjoy running my servers manually but feel free to make a Procfile/Docker set up if you like!

1. Clone the repo
2. Install dependencies
  - `cd client && npm install`
  - `cd server && bundle install`
3. Set up the database
  - `cd server && rails db:setup db:seed`
4. Run the frontend server in one terminal
  - `cd client && npm run dev`
5. Run the backend server
  - `cd server && rails server`
6. Open `http://localhost:5173/` in your browser and enjoy! 🎉

You'll need to set up the environment variables for the backend to work with the AI providers if you want.
Just create one account at Stability and/or OpenAI and look for their API Keys.

#### Contributing

Feel free to open a PR or an issue if you find something that could be improved.
At this point there are many features and improvements to be made, so I'll be happy to accept any help.

Please make sure tests are passing before opening a PR.

```bash
cd server # if you are not already there
bundle exec rspec # or just rspec if you have it installed globally
```
After running the tests you can check the coverage report at `server/coverage/index.html`.

If you have the open command:
```bash
open server/coverage/index.html # or just coverage/index.html if you are already in the server folder
```

#### Code Metrics

This will be in the CI pipeline soon, but for now you can run the following commands to check for code metrics.

##### Server

```bash
cd server # if you are not already there
```

Then you can run any of the following commands to check for code metrics:

```bash
bundle exec brakeman
bundle exec rails_best_practices .
bundle exec rubocop
bundle exec rubycritic
```

#### License

MIT
