# encoding : utf-8
class Admin::CategoriesController < BeautifulController

  before_filter :load_categories, :only => [:show, :edit, :update, :destroy]

  # Uncomment for check abilities with CanCan
  #authorize_resource

  def index
    session[:fields] ||= {}
    session[:fields][:categories] ||= (Categories.columns.map(&:name) - ["id"])[0..4]
    do_select_fields(:categories)
    do_sort_and_paginate(:categories)
    
    @q = Categories.search(
      params[:q]
    )

    @categories_scope = @q.result(
      :distinct => true
    ).sorting(
      params[:sorting]
    )
    
    @categories_scope_for_scope = @categories_scope.dup
    
    unless params[:scope].blank?
      @categories_scope = @categories_scope.send(params[:scope])
    end
    
    @categories = @categories_scope.paginate(
      :page => params[:page],
      :per_page => 20
    ).all

    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json{
        render :json => @categories_scope.all 
      }
      format.csv{
        require 'csv'
        csvstr = CSV.generate do |csv|
          csv << Categories.attribute_names
          @categories_scope.all.each{ |o|
            csv << Categories.attribute_names.map{ |a| o[a] }
          }
        end 
        render :text => csvstr
      }
      format.xml{ 
        render :xml => @categories_scope.all 
      }             
      format.pdf{
        pdfcontent = PdfReport.new.to_pdf(Categories,@categories_scope)
        send_data pdfcontent
      }
    end
  end

  def show
    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json { render :json => @categories }
    end
  end

  def new
    @categories = Categories.new

    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json { render :json => @categories }
    end
  end

  def edit
    
  end

  def create
    @categories = Categories.create(params[:categories])

    respond_to do |format|
      if @categories.save
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_categories_path(:mass_inserting => true)
          else
            redirect_to admin_categories_path(@categories), :notice => t(:create_success, :model => "categories")
          end
        }
        format.json { render :json => @categories, :status => :created, :location => @categories }
      else
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_categories_path(:mass_inserting => true), :error => t(:error, "Error")
          else
            render :action => "new"
          end
        }
        format.json { render :json => @categories.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @categories.update_attributes(params[:categories])
        format.html { redirect_to admin_categories_path(@categories), :notice => t(:update_success, :model => "categories") }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @categories.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @categories.destroy

    respond_to do |format|
      format.html { redirect_to admin_categories_url }
      format.json { head :ok }
    end
  end

  def batch
    attr_or_method, value = params[:actionprocess].split(".")

    @categories = []    
    
    Categories.transaction do
      if params[:checkallelt] == "all" then
        # Selected with filter and search
        do_sort_and_paginate(:categories)

        @categories = Categories.search(
          params[:q]
        ).result(
          :distinct => true
        )
      else
        # Selected elements
        @categories = Categories.find(params[:ids].to_a)
      end

      @categories.each{ |categories|
        if not Categories.columns_hash[attr_or_method].nil? and
               Categories.columns_hash[attr_or_method].type == :boolean then
         categories.update_attribute(attr_or_method, boolean(value))
         categories.save
        else
          case attr_or_method
          # Set here your own batch processing
          # categories.save
          when "destroy" then
            categories.destroy
          end
        end
      }
    end
    
    redirect_to :back
  end

  def treeview

  end

  def treeview_update
    modelclass = Categories
    foreignkey = :categories_id

    render :nothing => true, :status => (update_treeview(modelclass, foreignkey) ? 200 : 500)
  end
  
  private 
  
  def load_categories
    @categories = Categories.find(params[:id])
  end
end

