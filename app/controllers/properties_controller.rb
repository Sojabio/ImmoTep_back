class PropertiesController < ApplicationController
  before_action :set_property, only: %i[ show update destroy ]
  before_action :user_is_current_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create]

  # GET /properties
  def index
    @properties = Property.all

    render json: @properties
  end

  # GET /properties/1
  def show
    render json: @property
  end

  # POST /properties
  def create
    puts "Current user: #{current_user.inspect}"
    @property = Property.new(property_params)
    # @property = current_user.properties.new(property_params)

    if @property.save
      render json: @property, status: :created, location: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /properties/1
  def update
    if @property.update(property_params)
      render json: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  # DELETE /properties/1
  def destroy
    @property.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(:title, :price, :description, :user_id)
    end

    def user_is_current_user
      unless current_user == @property.user
        render json: { error: "Accès non autorisé" }, status: :unauthorized
      end
    end
end
