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
[C. Create Devise](#C)
[D. Create Tables](#D)
[E. Create a Notes Route](#E)

***

## <a id="A"> A. Getting Started </a>
1. Clone a new repo from https://github.com/new?template_name=rails-7-template&template_owner=appdev-projects 
2. Immediately create a branch: `git checkout -b rg_begin`

```
rg_begin % git status
On branch rg_begin
```

## <a id="B"> B. Adding Python to Rails </a>

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

## <a id="C"> C. Create Devise </a>
ref.: bulletin-board-2

1. Make sure you add to your Gemfile: `gem 'devise'`.
2. Type in terminal: `bundle install`. Review the output. Make sure that devise is included.
3. Run: `rails generate devise:install`.
4. Follow the instructions in the output.
5. Generate user model: `rails generate devise User`.
6. Type: `rails db:migrate`.
7. If the installation is successful, you will seee in config/routes.rb the line: `devise_for :users`.
8. Add sign-in/sign-out links:

app/views/layouts/application.html.erb

```
<!DOCTYPE html>
<html>
<head>
  <title>MyApp</title>
  <%= csrf_meta_tags %>
  <%= csp_meta_tag %>

  <%= stylesheet_link_tag 'application', media: 'all' %>
  <%= javascript_pack_tag 'application' %>
</head>

<body>
  <% if user_signed_in? %>
    <p>Welcome, <%= current_user.email %>!</p>
    <%= link_to 'Edit profile', edit_user_registration_path %> |
    <%= link_to 'Logout', destroy_user_session_path, method: :delete %>
  <% else %>
    <%= link_to 'Sign up', new_user_registration_path %> |
    <%= link_to 'Login', new_user_session_path %>
  <% end %>
  
  <%= yield %>
</body>
</html>
```

9. Display the sign-in page if user has not signed in.
controllers/pages_controller.rb

```
class PagesController < ApplicationController
  before_action :authenticate_user!
  
  def home
    user_input = "10"
    @heart = `python3 lib/assets/python/heart.py #{user_input}`
  end
end

```

## <a id="D"> D. Create Tables</a>

1. Create the following tables. User table has been created when creating devise.
- topic: `rails generate model Topic name:string`. Type: `rails db:migrate`.
- note: `rails generate model Note title:string content:text user:references topic:references`. Type: `rails db:migrate`.
- favorite: `rails generate model Favorite user:references note:references`. Type: `rails db:migrate`.

2. Make sure the table relations look correct. If not, please correct it:

- app/models/topic.rb:
```
class Topic < ApplicationRecord
  has_many :notes, dependent: :destroy

  validates :name, presence: true
end
```

- app/models/note.rb:
```
class Note < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_many :favorites, dependent: :destroy

  validates :title, :content, presence: true
end
```

- app/models/favorite.rb:
```
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :note

  validates :user_id, :note_id, presence: true
end
```

- app/models/user.rb:
```
class User < ApplicationRecord
  has_many :notes, dependent: :destroy
  has_many :favorites, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
end
```

- add a new column called username in the user table:

```
rails generate migration AddUsernameToUsers username:string
```

- Edit the Migration File:

```
class AddUsernameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string, null: false, unique: true
  end
end
```

- Update user model:

```
class User < ApplicationRecord
  # Other existing associations and validations

  validates :username, presence: true, uniqueness: true

  # Additional model logic
end
```

- Run: `rails db:migrate`.

3. Add a new field in user table called username: `rails generate migration AddUsernameToUsers username:string`. Edit migration file:

```
class AddUsernameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string

    User.reset_column_information
    User.find_each do |user|
      user.update_columns(username: "user_#{user.id}")
    end

    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end
end
```

- Run: `rails db:migrate`.

- Update user model:

```
class User < ApplicationRecord
  # Other existing associations and validations

  validates :username, presence: true, uniqueness: true

  # Additional model logic
end
```

- Update strong parameters for using devise:

app/controllers/application_controller.rb

```
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
```

4. Add to the sign up form this new field called username. Make it required. To do so, edit the file `views/devise/registrations/new.html.erb`. For the sign_in page, the file is `views/devise/sessions/new.html.erb`.

## <a id="E"> E. Create a Notes Route </a>

1. Execute the RCAV pattern to create the scaffold command. In this case, we already have the notes table in existence, so the command is `scaffold_controller` rather than just `scaffold`. `rails generate scaffold_controller Note title:string content:text user:references`.

2. Update routes, so it becoes accessible:

```
Rails.application.routes.draw do
  resources :notes
  # other routes
end
```

3. You should see a new file called `controllers/notes_controller.rb` being created. In addition, a new folder views/notes is created.

4. The newly generated elements will be linked automatically to the existing table and its fields. 

# Appendix:

## A. References
1. Video on MVP: https://www.youtube.com/watch?v=QRZ_l7cVzzU
2. Adding python: https://www.youtube.com/watch?v=3xBhwZpMo_Y&t=3s (1:10 min)
