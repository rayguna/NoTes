# Rails Template

This is a base Ruby on Rails repository configured for learning with Codespaces (and Gitpod).

- Ruby version: `3.2.1`
- Rails version: `7.1.3.3`


We've added additional Ruby gems and other software that aren't automatically available in a new Rails app, and configured 

### UJS and Turbo

In Rails version 7, support for Unobtrusive JavaScript (UJS) is not the default. Rather, [this has been replaced with Turbo](https://guides.rubyonrails.org/working_with_javascript_in_rails.html#turbo).

However, in AppDev, we typically want to first demonstrate UJS and then enable Turbo manually when we want it.

Therefore, UJS has been pre-configured here with these steps: 

- Pin UJS + jQuery in `config/importmap.rb` by running:

    ```
    % ./bin/importmap pin @rails/ujs
    % ./bin/importmap pin jquery
    ```

- Add UJS + jQuery via:

    ```js
    // app/javascript/application.js
    import jquery from "jquery";
    window.jQuery = jquery;
    window.$ = jquery;
    import Rails from "@rails/ujs"
    Rails.start();
    ```

UJS and Turbo can co-exist side-by-side with [these instructions, which we already implemented here](https://github.com/hotwired/turbo-rails/blob/main/UPGRADING.md#upgrading-from-rails-ujs--turbolinks-to-turbo).

By default, Turbo is disabled via:

```js
// app/javascript/application.js
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
```

Set it to `true` to enable Turbo everywhere, or you can use `data-turbo="true"` to enable Drive on a per-element basis while leaving it globally `false`.

### Additional gems:

- [`appdev_support`](https://github.com/firstdraft/appdev_support)
- [`annotate`](https://github.com/ctran/annotate_models)
- [`awesome_print`](https://github.com/awesome-print/awesome_print)
- [`better_errors`](https://github.com/BetterErrors/better_errors)
- [`binding_of_caller`](https://github.com/banister/binding_of_caller)
- [`dotenv-rails`](https://github.com/bkeepers/dotenv)
- [`draft_generators`](https://github.com/firstdraft/draft_generators/)
- [`draft_matchers`](https://github.com/jelaniwoods/draft_matchers/)
- [`devise`](https://github.com/heartcombo/devise)
- [`faker`](https://github.com/faker-ruby/faker)
- [`grade_runner`](https://github.com/firstdraft/grade_runner/)
- [`htmlbeautifier`](https://github.com/threedaymonk/htmlbeautifier/)
- [`http`](https://github.com/httprb/http)
- [`pry_rails`](https://github.com/pry/pry-rails)
- [`rails_db`](https://github.com/igorkasyanchuk/rails_db)
- [`rails-erd`](https://github.com/voormedia/rails-erd)
- [`rspec-html-matchers`](https://github.com/kucaahbe/rspec-html-matchers)
- [`rspec-rails`](https://github.com/rspec/rspec-rails)
- [`rufo`](https://github.com/ruby-formatter/rufo)
- [`specs_to_readme`](https://github.com/firstdraft/specs_to_readme)
- [`table_print`](https://github.com/arches/table_print)
- [`web_git`](https://github.com/firstdraft/web_git)
- [`webmock`](https://github.com/bblimke/webmock)

### Additional software:
- OS Ubuntu 20.04.5 LTS
- Chromedriver
- Fly.io's `flyctl`
- Google Chrome (headless browser)
- Graphviz
- Node JS 18
- NPM 8.19.3
- Postgresql 12
- Redis
- Yarn

### VS Code extensions:
- vortizhe.simple-ruby-erb
- mbessey.vscode-rufo
- aliariff.vscode-erb-beautify
- eamodio.gitlens
- setobiralo.erb-commenter

# NOTES - TOC

[A. Getting Started](#A) 

[B. Adding Python to Rails](#B)

[C. Create Tables](#C)

[D. Create Sign-in and Sign-out Page](#D)

***

## <a id="A"> A. Getting Started </a>
1. Clone a new repo from https://github.com/new?template_name=rails-7-template&template_owner=appdev-projects 
2. Immediately create a branch: `git checkout -b rg_begin`

```
rg_begin % git status
On branch rg_begin
```

## <a id = "B"> B. Adding Python to Rails </a>

1. Let's do a quick test to incorporate python to rails.
2. First, automate the RCAV pattern by typing into the terminal: `rails g controller pages home`. In this case, the controller is named pages and the action is named home.
3. Add the following to config/routes/rb.
```
Rails.application.routes.draw do
  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  root "pages#home"
  get 'pages/home'
end
```
4. run bin/dev to see the following message:
```
Pages#home
Find me in app/views/pages/home.html.erb
```
5. Modify the views/pages/home.html.erb file as follows (2 min):

```
<h1>Home</h1>
<p>It's where the <%= @heart %></p>
````

6. Modify `controllers/pages_controller.rb` as follows (3:20 min):

```
class PagesController < ApplicationController
  def home
    our_input_text = "heart"
    @heart = `python3 lib/assets/python/heart.py #{our_input_text}`
  end
end
```

7. Ceeate a pyton file within a new folder called python: `lib/assets/python/heart.py` (4 min):

```
import sys

input = sys.argv[1]
print input + " is"
```

8. Try running numpy. First, install numpy:

```
sudo apt update
sudo apt install -y python3 python3-pip
pip3 --version
pip3 install numpy
```

9. Install openai with `pip3 install openai`. Test the installation by typing in the terminal:

```
python3

import openai
```

## <a id="C"> C. Create Tables<a>

1. Create the four tables using the commands:

```
rails generate model User email:string password:string username:string  
rails generate model Topic name:string
rails generate model Note title: text content:text user:references topic:references
rails generate model Favorite note:references user:references
```

Run the migration (optional):

```
rails db:migrate
```

2. Define the associations:

```
#app/models/user.rb
class User < ApplicationRecord
  has_many :notes
  has_many :favorites
  has_many :favorite_notes, through: :favorites, source: :note
end

#app/models/topic.rb
class Topic < ApplicationRecord
  has_many :notes
end

#app/models/note.rb
class Note < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_many :favorites
  has_many :favorited_by, through: :favorites, source: :user
end

#app/models/favorite.rb
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :note
end
```

3. Migrate the database once more (if you did previously) to keep it up to date:

```
rails db:migrate
```

## <a id = "D"> D. Create Sign-in and Sign-out Page </a>

1. Add the following to the Gemfile: `gem 'devise`.
2. Navigate into Gemfile with `cd Gemfile` and run: `bundle install`.
3. Type `cd..` to return to the upper directory. Run devise install generator: `rails generate devise:install`.
4. IMPORTANT! Follow the instructions provided in the output. You might need to configure the default URL options in your config/environments/development.rb file:
`config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }`.
5. Generate user model: `rails generate devise User`. Followed by: `rails db:migrate`. 
6. Set up views to customize the sign-in/sign-out page: `rails generate devise:views`.
7. Check to make sure the routes for user sign-in and sign-out is added automatically in `config/routes.rb`. You should see `devise_for :users`.
8. Add the following links within `app/views/layouts/application.html.erb`:
  ```
  <% if user_signed_in? %>
    <%= link_to 'Sign Out', destroy_user_session_path, method: :delete %>
  <% else %>
    <%= link_to 'Sign In', new_user_session_path %>
    <%= link_to 'Sign Up', new_user_registration_path %>
  <% end %>
  ```
9. Add restrictions to access certain pages for signed-in users using `before-action` filter in the controller. Here is the syntax for restricting the `home` controller:

  ```
  class HomeController < ApplicationController
    before_action :authenticate_user!
    
    def index
      # Your code here
    end
  end
  ```

10. Get an error message:

```
Migrations are pending. To resolve this issue, run:
        bin/rails db:migrate
```

This is possibly due to user table being created previously.

- Return to the initial version where tables have not been created. Create devise first, followed by the remaining tables.

- To return to the previous version, type: `git checkout 1d3e212`.
- Start a new branch: `git switch -b rg_devise_first`.

# Appendix:

## A. References
1. Video on MVP: https://www.youtube.com/watch?v=QRZ_l7cVzzU
2. Adding python: https://www.youtube.com/watch?v=3xBhwZpMo_Y&t=3s (1:10 min)
