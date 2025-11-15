# BAMSFX ONLINE SHOP - README _(Work in Progress)_
Hello,
Here is my online Sound Effects shop that I am building. The first stage is completed and the app is up and running here: https://www.bamsfx.com

## SEO implementation
[chatGPT](https://chatgpt.com/share/67bb37ac-85c0-8006-9a97-89ee64fb1273)

## Social Media Link Preview Optimization (Open Graph & Twitter Card Integration)
The idea is to customize the text and image being displayed when posting different pages of you app

1- Modify the code in your `application.html.erb` to implemnent a default behaviour that yields to the customized behaviour when there is one
```erb
# application.html.erb
<head>
(...)
    # meta
    <meta property="og:title" content="<%= content_for?(:meta_title) ? yield(:meta_title) : 'BamSFX - Professional Sound Effects to elevate your projects to the next level' %>">
    <meta property="og:description" content="<%= content_for?(:meta_description) ? yield(:meta_description) : 'Find the perfect sound effect for your project.' %>">
    <meta property="og:image" content="<%= content_for?(:meta_image) ? yield(:meta_image) : image_url("https://res.cloudinary.com/dk9a86uhu/image/upload/v1695194012/sfx_shop/BamSFX_meta_vcgic4.png") %>">
    <meta property="og:url" content="<%= request.original_url %>">
    <meta property="og:site_name" content="BAM Sound Effects" />
    <meta property="og:type" content="website" />

    # twitter
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:site" content="BAM Sound Effects">
    <meta name="twitter:title" content="<%= content_for?(:meta_title) ? yield(:meta_title) : 'BAM Sound Effects' %>">
    <meta name="twitter:description" content="<%= content_for?(:meta_description) ? yield(:meta_description) : 'Sound FX shop | Find the perfect sound effects for your project!' %>">
    <meta name="twitter:creator" content="@OGmusik">
    <meta name="twitter:image" content="<%= content_for?(:meta_image) ? yield(:meta_image) : image_url('https://res.cloudinary.com/dk9a86uhu/image/upload/v1695194012/sfx_shop/BamSFX_meta_vcgic4.png') %>">
(...)
</head>
```
2- Customize the behaviour in the specific pages. Here is an example
```erb
# app/views/sfx_packs/show.html.erb
<% content_for :meta_title, @pack.title %>
<% content_for :meta_description, @pack.description %>
<% content_for :meta_image, @pack.photos.attached? ? url_for(@pack.photos.first) : image_url("https://res.cloudinary.com/dk9a86uhu/image/upload/v1695194012/sfx_shop/BamSFX_meta_vcgic4.png") %>

(...)
```

## THE DIFFERENT STAGES I AM AIMIMG FOR WITH THIS APP

Here are the different stages that I am aiming:

### Stage 1: **COMPLETED**
Creating a Sound Effects online shop with only my Own sound effects packs.
I am first releasing a Demo version for friends and coleagues, with free access to all sound effect packs. Official release will come soon after.

### Stage 2: Official release **COMPLETED**
The website was officially opened to business on January 2022. Check out [BAMSFX.COM shop](https://www.bamsfx.com)

### Stage 3: Create your own SFX Pack -> COLLECTIONS **COMPLETED**
Collections: The customer can purchase sounds individually or make their own packs with hand picked sounds, in order to benefit from "pack prices" while not having to purchase pre-made packs. Gives more flexibillity to the customer with smaller budgets.

### Stage 4: 2025 - In progress
Onboard other sound designers to sell their Sound Effect packs after quality validation from me.
The question is whether they will be able to manage their packs and sounds or will I be the sole administrator.
Payment details and share aspect need to be established.

### Additional features:
- Implement PAYPAL
- Suggestion Forum: customers can discuss and make suggestions for wishes they may have for sound effects.
- Player: An option for board game players (like DnD) to have access to ALL sounds available and create their own playlist curated for their sessions. This option will prbably work through subscription (24h - 7day - monthly)
- Custom work: for clients to ask for custom designs for their projects. They can ask one of the sound designers from the website, or make open offers.

I will add details about how I build this app and the various tools I used (devise, postgresql, cloudinary, stripe, heroku...) soon! 

## GEMS AND FEATURES

### Devise

**Devise** is a pretty straight forward build-in pack that makes **authentification** super easy to implement. I will describe the different steps here: _Coming Soon_

### Stripe

**Stripe** is an awesome payment tool super easy to implement. I will describe the different steps here: _Coming Soon_

**Testing webhooks with ngrok**
There is a conflict between the **ngrok gem** and the **javascript package** causing the ngrok library to be located in the wrong place. To fix that:

1/ To fix that:
- run `which ngrok` in the terminal
- if you get `/Users/oliviergirardot/.rbenv/shims/ngrok`, this is **WRONG**
- run the following command to fix it: `rm -f ~/.rbenv/shims/ngrok` and proceed with the normal process.

2/ In terminal run: 
```
ngrok http 3000
```
3/ Get link like this one ```https://04a7-87-123-193-136.ngrok.io``` <br>
and paste it in config/environments/development.rb like so:
```
config.hosts << "04a7-87-123-193-136.ngrok.io"
```
4/ Create a webhook on stripe with the rendered link like so:
```
https://04a7-87-123-193-136.ngrok.io/stripe-webhooks
```
5/ Get STRIPE_WEBHOOK_SECRET_KEY  from webhook on stripe test
And replace it in the ```.env``` file!
```
STRIPE_WEBHOOK_SECRET_KEY=whsec_something
```
6/ In terminal run:
```
rails s
```

### Wavesurfer
**[Wavesurfer.js](https://wavesurfer-js.org/)** is a tool to display audio waveforms and offers the possibility to customize them, including style, colors, play functions and so on.

**1/ installation**
```
yarn add wavesurfer.js
``` 
**2/ import**
```
import WaveSurfer from 'wavesurfer.js';
``` 
**3/ html container**
```
<div id="waveform"></div>
```
**4/ javascript implementation**

Create an instance, passing the container selector and options:
```
var wavesurfer = WaveSurfer.create({
    container: '#waveform',
    waveColor: 'violet',
    progressColor: 'purple'
});
```
Subscribe to some events:
```
wavesurfer.on('ready', function () {
    wavesurfer.play();
});
```
Load an audio file from a URL:
```
wavesurfer.load('example/media/demo.wav');
```
**5/ resources**

[original resource](https://github.com/katspaugh/wavesurfer.js)<br>
[Wavesurfer Website](https://wavesurfer-js.org/api/)<br>
Waveform [options](http://wavesurfer-js.org/docs/options.html)<br>
Waveform [methods](http://wavesurfer-js.org/docs/methods.html)

**6/ my code for multiple tracks**

HTML
```
<div class="wave" id="id<%= track.id %>" data-link="<%= track.link %>"></div>
<i class="far fa-play-circle" id="playid<%= track.id %>"></i>
<i class="far fa-pause-circle" id="stopid<%= track.id %>" style="display: none"></i>
```

javascript
```
import WaveSurfer from 'wavesurfer.js';

// multiple track display

window.addEventListener('DOMContentLoaded', () => {
  // loading watermark
  let watermark = new Audio('https://single-track-list.s3.eu-central-1.amazonaws.com/watermark/watermark.mp3');
  // creates an empty array which will be implemented with every container id (see push() function bellow)
  let wavesurfers = [];
  // creating undefined variable to be used in play() function and store the current file playing (if any)
  let audioPlaying;
  //inserting wavesurferplayer
  document.querySelectorAll('.wave').forEach((el, loopId) => {
    let id = el.id;
    wavesurfers.push(id);
    let link = el.dataset.link;
    wavesurfers[loopId] = WaveSurfer.create({
      container: `#${id}`,
      barWidth: 2,
      barHeight: 1,
      barGap: null,
      waveColor: '#CCCCCC',
      progressColor: '#FFA500',
      height: 50
    });
    // loading wavesurfer
    wavesurfers[loopId].load(link);

    // display track duration in index view
    wavesurfers[loopId].on('ready', () => {
      document.getElementById(`trackDuration${id}`).innerText = wavesurfers[loopId].getDuration();
    })

    // play and pause buttons
    let playButton = document.getElementById(`play${id}`);
    let stopButton = document.getElementById(`stop${id}`);

    playButton.addEventListener('click', () => {
      // stop watermark if any
      watermark.pause();
      // this will stop any audio playing when pressing start
      if (audioPlaying != undefined) {
        audioPlaying.stop()
      };
      playButton.style.display = "none";
      stopButton.style.display = "";
      wavesurfers[loopId].play();
      // this re-assigns the current file playing to the variable audioPlaying (every time you press play)
      audioPlaying = wavesurfers[loopId];
      // get duration of audio
      const duration = audioPlaying.getDuration()
      
      // play watermark and stop watermark
      if (duration < 3) {
        watermark.play()
      } else {
        watermark.play()

        // the reason why I chose this approach is for clearInterval() to be called within 1 second
        // rather than 8 seconds like before, when I set the interval to 8 seconds and we couls hear
        // another watermark eventhough the audio had stoped, up to 8 seconds after.
        let i = 1;
        let interval = setInterval(() => {
          i ++;
          if (i === 8) {
            watermark.play()
            i = 1;
          }
          if (!wavesurfers[loopId].isPlaying()) {
            clearInterval(interval);
          }
        }, 1000)
      }
    });

    // making sure button play stays on play when clicking waveform
    wavesurfers[loopId].on('play', function () {
      stopButton.style.display = "";
      playButton.style.display = "none";
    });

    stopButton.addEventListener('click', () => {
      stopButton.style.display = "none";
      playButton.style.display = "";
      wavesurfers[loopId].pause();
    })

    // swaps icon from play to pause automatically when track reaches the end
    wavesurfers[loopId].on('pause', function () {
      stopButton.style.display = "none";
      playButton.style.display = "";
    });
  })
  
  // stop audio playing before leaving page
  window.addEventListener('beforeunload', (event) => {
    event.preventDefault();
    audioPlaying.stop();
  });
});
```

### Kaminari GEM (pagination)

This cool gem is the most popular **pagination** gem at this time (end of 2021), you can find some documentation **[here](https://github.com/kaminari/kaminari)**

_Basic Instructions:_ <br> <br>
In your Gemfile, add: ```gem 'kaminari'``` <br> <br>
run ```bundle install``` in your terminal <br> <br>
Generate the **kaminari** config file by running ```rails g kaminari:config``` in your terminal <br> <br>
Generate views: ```rails generate kaminari:views default``` <br> <br>
-> instead of _default_ here is a list of available themes: bootstrap2, bootstrap3, bootstrap4, bourbon, bulma, foundation, foundation5, github, google, materialize, purecss, semantic_ui. <br> <br>
Of course you can customize your views by overriding preset styling. In the views under the **kaminari** folder, you can find the different view files, and the styling classes. <br><br>
Customize the **kaminari_config.rb** file: <br>
```
# frozen_string_literal: true

Kaminari.configure do |config|
  config.default_per_page = 25 // example of customization
  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.max_pages = nil
  # config.params_on_first_page = false
end
```

In your **controller** add
``` User.all.page params[:page] ```
<br>
### Download Individual Tracks (hosted on AWS S3) grouped in a Zip file:
#### Gems:
````
gem 'aws-sdk-s3', '~> 1.103'
gem 'aws-sdk-ec2', '~> 1.0.0.rc3'
gem 'rubyzip', '~> 1.2'
`````
**Don't forget to** ```bundle```
<br>
#### add your s3 KEYS to the ```.env``` file:
You can find your credential keys: **https://console.aws.amazon.com/iam/home#/users/IAM_USER**
In your ```.env``` file add the keys like so:
````
AWS_ACCESS_KEY_ID=[YOUR ACCESS KEY ID]
AWS_SECRET_ACCESS_KEY=[YOUR SECRET ACCESS KEY]
````
### Don't forget to add those keys to production

Implement the downlaod process in your three files ```routes. rb```, ```view.rb```, ```controller.rb```

### Example (my own implementation)
#### routes.rb
````
get 'create_zip', to: 'single_tracks#create_zip'
````
#### dashboard.rb
```
<%= link_to "download all", create_zip_path(tracks: @tracks) %>
```
#### single_tracks_controller.rb
````
def create_zip
    Aws.config.update({
      region: 'eu-central-1',
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    })

    s3 = Aws::S3::Resource.new
    bucket = s3.bucket('single-track-list')
    files = []
    tracks = params[:tracks]
    tracks.each do |track|
      name = SingleTrack.find(track).link.split('/').last
      files << name
    end
    time = Time.now.to_i
    folder = "#{current_user.username}_#{time}"
    Dir.mkdir(Rails.root.join('app', 'assets', 'uploads', folder))
    files.each do |file_name|
      file_obj = bucket.object(file_name)
      file_obj.get(response_target: Rails.root.join('app', 'assets', 'uploads', folder, file_name))

    end
    require 'zip'
    require 'fileutils'
    Zip::File.open(Rails.root.join('app', 'assets', 'uploads', folder, "#{folder}.zip"), Zip::File::CREATE) do |zipfile|
      files.each do |file_name|
       # Add the file to the zip
        zipfile.add(file_name, File.join(Rails.root.join('app', 'assets', 'uploads', folder, file_name)))
      end
    end
    send_file Rails.root.join('app', 'assets', 'uploads', folder, "#{folder}.zip"), :disposition => 'attachment'
  end
````

### Heroku upgrade to 22

1- Create a second heroku remote:
```heroku create --remote heroku-22 --stack heroku-22 <your app name>-heroku-22 --region eu```
<br>
**(Work on a branch)**
<br>
2- Update gem file:<br>
```ruby "3.1.2"
gem "pg", "~> 1.1"
gem "cloudinary"
gem 'rails', '~> 6.0' # IF RAILS < 6
gem 'psych', '< 4' # IF assets:precompile issue
gem 'net-smtp', require: false
gem 'net-imap', require: false
gem 'net-pop', require: false
```
<br>
**Run in terminal**

```bundle lock --add-platform x86_64-linux```

3- update active storage<br>
    - ```rails active_storage:update```<br>
    - ```run rails db:migrate```

4- Bundle:<br>
	- remove Gemfile.lock <br>
	- ```bundle``` <br>
    - ```bundle lock --add-platform x86_64-linux```

5- Add webpack-cli package: **OPTIONAL** <br>
	- ```yarn add webpack-cli``` <br>
	- You may need to remove **node_modules** & **yarn.lock** before running

6- Commit: <br>
	- ```ga . && gcmsg “message”```

7- Push to heroku-22: <br>
	- ```git push heroku-22 master``` <br>
	- ```heroku run rails db:migrate db:seed --app whatever-the-remote-repo-is-called```  

8- Push to official heroku repo <br>
	- Go to heroku/settings and click on **Upgrade Stack** <br>
	- ```git push heroku master``` <br>
	- ```heroku run rails db:migrate```
