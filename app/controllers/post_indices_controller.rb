class PostIndicesController < ApplicationController
  helper :application
  before_filter :require_user

  # GET /post_indices
  # GET /post_indices.json
  def index
    @post_indices = PostIndex.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @post_indices }
    end
  end

  # GET /post_indices/1
  # GET /post_indices/1.json
  def show
    @post_index = PostIndex.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post_index }
    end
  end

  # GET /post_indices/new
  # GET /post_indices/new.json
  def new
    @post_index = PostIndex.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post_index }
    end
  end

  # GET /post_indices/1/edit
  def edit
    @post_index = PostIndex.find(params[:id])
  end

  # POST /post_indices
  # POST /post_indices.json
  def create
    @post_index = PostIndex.new(params[:post_index])

    respond_to do |format|
      if @post_index.save
        format.html { redirect_to @post_index, notice: 'Post index was successfully created.' }
        format.json { render json: @post_index, status: :created, location: @post_index }
      else
        format.html { render action: "new" }
        format.json { render json: @post_index.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /post_indices/1
  # PUT /post_indices/1.json
  def update
    @post_index = PostIndex.find(params[:id])

    respond_to do |format|
      if @post_index.update_attributes(params[:post_index])
        format.html { redirect_to @post_index, notice: 'Post index was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @post_index.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /post_indices/1
  # DELETE /post_indices/1.json
  def destroy
    @post_index = PostIndex.find(params[:id])
    @post_index.destroy

    respond_to do |format|
      format.html { redirect_to post_indices_url }
      format.json { head :ok }
    end
  end
end
