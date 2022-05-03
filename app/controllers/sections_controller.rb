class SectionsController < BaseController
    def index
        authorize :section
    end

end