# NOTES - TOC

[A. Getting Started](#A)
[B. Adding Python to Rails](#B)
[C. Create Devise](#C)
[D. Create Tables](#D)
[E. Create New Routes](#E)
[F. Create a Carousel](#F)
[G. Edit form fields](#G)
[H. Add the Remaining Routes with Scaffolds](#H)

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

## <a id="E"> E. Create Note Routes </a>

1. Execute the scaffold command to create the RCAV pattern. In this case, we already have the notes table in existence, so the command is `scaffold_controller` rather than just `scaffold`. `rails generate scaffold_controller Note title:string content:text user:references`.

2. Update routes, so it becomes accessible; It should be updated automatically.

```
Rails.application.routes.draw do
  resources :notes
  # other routes
end
```

3. You should see a new file called `controllers/notes_controller.rb` being created. In addition, a new folder views/notes is created.

4. The newly generated elements will be linked automatically to the existing table and its fields. 

## <a id="F"> F. Create a Carousel </a>

Added carousel to the log in page using bootstrap.

## <a id="G"> G. Edit form fields </a>

Remember to edit the permit method input to include the new field anytime you introduce a new parameter within the controller:

```
params.require(:note).permit(:title, :content, :user_id, :topic_id)
```

## <a id="H"> H. Add the Remaining Routes with Scaffolds </a> 

1. Execute the scaffold command to create the RCAV pattern. In this case, we already have the topics table in existence, so the command is `scaffold_controller` rather than just `scaffold`. 

- For Topics table : `rails generate scaffold_controller Topic name:string`.
- For User table: `rails generate scaffold_controller User email:string encrypted_password:string remember_created_at:datetime reset_password_sent_at:datetime reset_password_token:string username:string`.
- For Favorite table: `rails generate scaffold_controller Favorite note_id:integer user_id:integer`.

2. Update routes, so it becomes accessible; It should be updated automatically.

```
Rails.application.routes.draw do
  resources :favorites
  resources :users
  resources :topics
  resources :notes
  devise_for :users
  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  root "pages#home"
  #get 'pages/home'
end
```

3. You should see a new file called, e.g., `controllers/notes_controller.rb` being created. In addition, a new folder views/notes is created.

4. The newly generated elements will be linked automatically to the existing table and its fields. 

## I. Routing

1. To direct route to a specific page, you need to incorporate several changes, as follows. Essentially, you need to save the dynamic route into the params hash. In this example, the action is new/create.

  - Modify the "New Note" link on the topics/1 page to pass the dynamic route, `@topic_id`, called `topic_id`. This command saves the value of topic id within the params hash.
    ```
    <!-- app/views/topics/show.html.erb -->
    <%= link_to 'New Note', new_note_path(topic_id: @topic.id) %>
    ```
  - Ensure the new action initializes the @note with topic_id.
    ```
    # app/controllers/notes_controller.rb
    class NotesController < ApplicationController
      def new
        @note = Note.new(topic_id: params[:topic_id])
      end

      def create
        @note = Note.new(note_params)
        if @note.save
          redirect_to topic_path(@note.topic_id), notice: 'Note was successfully created.'
        else
          render :new
        end
      end

      private

      def note_params
        params.require(:note).permit(:title, :content, :topic_id)
      end
    end
    ```

  - Update the form for creating a new note to include a hidden field for topic_id.
    ```
    <!-- app/views/notes/new.html.erb -->
    ...
    <div>
      <%= link_to 'Back to Notes', topic_path(params[:topic_id]) %>
    </div>
    ```

  - Ensure the "Back" link on the new note form uses params[:topic_id].
    ```
    <!-- app/views/notes/_form.html.erb -->
    <%= form_with(model: note, local: true) do |form| %>
      <%= form.hidden_field :topic_id, value: note.topic_id %>
    ```

## J. Prevent user from creating duplicated topics or notes title

1. Go to app/models/topic.rb and modify it to:

```
class Topic < ApplicationRecord
  belongs_to :user

  validates :name, uniqueness: { scope: :user_id, message: "has already been taken for this user" }
end
```

2. In the terminal, type: `rails generate migration add_unique_index_to_topics_name_and_user_id`.

3. Edit the generated migration file to add the unique index:

```
class AddUniqueIndexToTopicsNameAndUserId < ActiveRecord::Migration[6.1]
  def change
    add_index :topics, [:name, :user_id], unique: true
  end
end
```

4. Run: `rails db:migrate`.

5. Do the same with notes model. You just have to add into the models/note.rb

  ```
  validates :title, uniqueness: { scope: [:user_id, :topic_id], message: "has already been taken for this topic and user" }
  ```

## K. Change Database Default from sqlite to Postgres

1. This is to prevent constant updates during testing.
2. To do so, modify the `config/database.yml` file.
3. Then, type rails `db:drop`, `rails db:create`, `rails db:migrate`.

## L. Generate sample data

1. Follow the tutorial in photogram-industrial.
, section O.

2. Write the commands within:

  ```
  #lib/tasks/dev.rake

  task sample_data: :environment do
    p "Creating sample data"
  end
  ```

3. Test using the command `rake sample data` in the terminal.

4. At the start of the file, make sure to destroy existing tables and reset the indices. Pick 5 random topics for each user from a list without replacement to make sure each user has exactly 5 topics and not less due to duplication.
5. Created datasets and saved into *.txt file. Exported datssets on local computer via github desktop. On codespaces, pull dataset with the command `git pull`.

## M. Add Ransack Search Tool

1. Add to Gemfile: `gem 'ransack', '~> 4.1.0'`. Type in terminal: `bundle install`.
2. Add to models/note.rb:
  ```
  def self.ransackable_attributes(auth_object = nil)
      # Return an array of attributes that can be searched
      %w[title content created_at updated_at]
    end
  ```
3. Place into the views/notes/index.html.erb page:
  ```
  <%q = Note.ransack(title_cont: "reaction")%>
  <%= "Test ransack #{q.result}" %>
  <%debugger%>
  ```
Type in the termnal: q.result. You will see the list of notes that meet the criteria.

4. Added bootstrap pagination as well.

## N. Added markdown 

1. Use redcarpet gem.
2. Define markdown method in the helper section.
3. Used js to dynamically update markdown preview for note content entry.
4. Display note contents as markdown.
5. To refactor the code, I place the render_markdown method in the helper folder. Since I want to make the method accessible both for the views and the controller, I had to include in the applicationcontroller:

  ``
  helper MarkdownHelper
  include MarkdownHelper # Include the module to make it available in controllers
  ``
- Use helper when you want to make methods available in views.
- Use include when you want to mix methods into a class so they can be used as instance methods within that class.

## O. Added chart toggle button

1. Added a toggle button to show/unshow user activities chart. This functionality is, however, slow. Ajaxify this in the future or consider some other feasible alternatives.

## P. Use Python

1. For python to work on render, I had to access the shell and manually installed the dependencies using the command, e.g., pip3 install matplotlib.
2. Use Bokeh in place of matplotlib for a dynamic plotting. 

## Q. Landing and signed in page

1. Made the sign in page to work using if-else conditions. Pass data to signed in page partials via the index controller.

## R. Moved ransack Search into Tools

1. Discovered that ransack search display search results for every user and resulted in duplicated outputs. Solved the issue by adding a constraint to search only within the current user datasets. 

# Appendix:

## A. References
1. Video on MVP: https://www.youtube.com/watch?v=QRZ_l7cVzzU
2. Adding python: https://www.youtube.com/watch?v=3xBhwZpMo_Y&t=3s (1:10 min)
