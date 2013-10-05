# encoding : utf-8
class Admin::TrabajadorsController < BeautifulController

  before_filter :load_trabajador, :only => [:show, :edit, :update, :destroy]

  # Uncomment for check abilities with CanCan
  #authorize_resource

  def index
    session[:fields] ||= {}
    session[:fields][:trabajador] ||= (Trabajador.columns.map(&:name) - ["id"])[0..4]
    do_select_fields(:trabajador)
    do_sort_and_paginate(:trabajador)
    
    @q = Trabajador.search(
      params[:q]
    )

    @trabajador_scope = @q.result(
      :distinct => true
    ).sorting(
      params[:sorting]
    )
    
    @trabajador_scope_for_scope = @trabajador_scope.dup
    
    unless params[:scope].blank?
      @trabajador_scope = @trabajador_scope.send(params[:scope])
    end
    
    @trabajadors = @trabajador_scope.paginate(
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
        render :json => @trabajador_scope.all 
      }
      format.csv{
        require 'csv'
        csvstr = CSV.generate do |csv|
          csv << Trabajador.attribute_names
          @trabajador_scope.all.each{ |o|
            csv << Trabajador.attribute_names.map{ |a| o[a] }
          }
        end 
        render :text => csvstr
      }
      format.xml{ 
        render :xml => @trabajador_scope.all 
      }             
      format.pdf{
        pdfcontent = PdfReport.new.to_pdf(Trabajador,@trabajador_scope)
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
      format.json { render :json => @trabajador }
    end
  end

  def new
    @trabajador = Trabajador.new

    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json { render :json => @trabajador }
    end
  end

  def edit
    
  end

  def create
    @trabajador = Trabajador.create(params[:trabajador])

    respond_to do |format|
      if @trabajador.save
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_trabajadors_path(:mass_inserting => true)
          else
            redirect_to admin_trabajador_path(@trabajador), :notice => t(:create_success, :model => "trabajador")
          end
        }
        format.json { render :json => @trabajador, :status => :created, :location => @trabajador }
      else
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_trabajadors_path(:mass_inserting => true), :error => t(:error, "Error")
          else
            render :action => "new"
          end
        }
        format.json { render :json => @trabajador.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @trabajador.update_attributes(params[:trabajador])
        format.html { redirect_to admin_trabajador_path(@trabajador), :notice => t(:update_success, :model => "trabajador") }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @trabajador.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @trabajador.destroy

    respond_to do |format|
      format.html { redirect_to admin_trabajadors_url }
      format.json { head :ok }
    end
  end

  def batch
    attr_or_method, value = params[:actionprocess].split(".")

    @trabajadors = []    
    
    Trabajador.transaction do
      if params[:checkallelt] == "all" then
        # Selected with filter and search
        do_sort_and_paginate(:trabajador)

        @trabajadors = Trabajador.search(
          params[:q]
        ).result(
          :distinct => true
        )
      else
        # Selected elements
        @trabajadors = Trabajador.find(params[:ids].to_a)
      end

      @trabajadors.each{ |trabajador|
        if not Trabajador.columns_hash[attr_or_method].nil? and
               Trabajador.columns_hash[attr_or_method].type == :boolean then
         trabajador.update_attribute(attr_or_method, boolean(value))
         trabajador.save
        else
          case attr_or_method
          # Set here your own batch processing
          # trabajador.save
          when "destroy" then
            trabajador.destroy
          end
        end
      }
    end
    
    redirect_to :back
  end

  def treeview

  end

  def treeview_update
    modelclass = Trabajador
    foreignkey = :trabajador_id

    render :nothing => true, :status => (update_treeview(modelclass, foreignkey) ? 200 : 500)
  end
  
  private 
  
  def load_trabajador
    @trabajador = Trabajador.find(params[:id])
  end
end

