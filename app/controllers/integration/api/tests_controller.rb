module Integration
  class Api::TestsController < Katello::Api::V2::ApiController
    
    respond_to :json

    include Api::Rendering

    before_filter :find_organization, :only => [:index, :create]
    before_filter :find_test, :only => [:show, :update, :destroy]

    def index
      ids = Test.readable.where(:organization_id => @organization.id).pluck(:id)
      filters = [:terms => {:id => ids}]

      options = {
        :filters => filters,
        :load_records? => true
      }

      respond_for_index(:collection => item_search(Test, params, options))
    end

    def show
      respond_for_show(:resource => @test)
    end

    def create
      @test = Test.new(test_params)
      @test.organization = @organization
      @test.save!

      respond_for_show(:resource => @test)
    end

    def update
      @test.update_attributes!(test_params)
      @test.save!

      respond_for_show(:resource => @test)
    end

    def destroy
      @test.destroy
      respond_for_show(:resource => @test)
    end

    protected

    def find_test
      @test = Test.find_by_id(params[:id])
      fail HttpErrors::NotFound, "Could not find test with id #{params[:id]}" if @test.nil?
      @test 
    end

    def test_params
      params.require(:test).permit(:name, :content, :build_step)
    end

  end
end