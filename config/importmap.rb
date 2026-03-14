# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/request.js", to: "https://ga.jspm.io/npm:@rails/request.js@0.0.13/src/index.js"

pin "tippy.js", to: "https://ga.jspm.io/npm:tippy.js@6.3.7/dist/tippy.esm.js"

pin_all_from "app/javascript/controllers", under: "controllers"

pin "date-fns", to: "https://ga.jspm.io/npm:date-fns@4.1.0/index.js"
pin "themes", to: "themes.js"
pin "github-canvas", to: "github-canvas.js"
pin "github-canvas-rating", to: "github-canvas-rating.js"
