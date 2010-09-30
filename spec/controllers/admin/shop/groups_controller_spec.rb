require 'spec/spec_helper'

describe Admin::Shop::GroupsController do
  
  dataset :users, :shop_groups
  
  before(:each) do
    login_as  :admin
  end
  
  describe '#new' do
    context 'instance variables' do
      it 'should be assigned' do
        get :new
        
        assigns(:inputs).should   === ['name']
        assigns(:meta).should     === []
        assigns(:buttons).should  === []
        assigns(:parts).should    === ['description']
        assigns(:popups).should   === []
      end
    end
  end
  
  describe '#edit' do
    context 'instance variables' do
      it 'should be assigned' do
        get :edit, :id => shop_groups(:breakfast).id
        
        assigns(:inputs).should   === ['name']
        assigns(:meta).should     === []
        assigns(:buttons).should  === ['browse_products']
        assigns(:parts).should    === ['description','products']
        assigns(:popups).should   === ['browse_products']
      end
    end
  end
  
  describe '#create' do
    context 'instance variables' do
      it 'should be assigned' do
        post :create, :shop_group => {}
        
        assigns(:inputs).should   === ['name']
        assigns(:meta).should     === []
        assigns(:buttons).should  === []
        assigns(:parts).should    === ['description']
        assigns(:popups).should   === []
      end
    end
  end
  
  describe '#update' do
    context 'instance variables' do
      it 'should be assigned' do
        put :update, :id => shop_groups(:breakfast).id, :shop_group => {}
        
        assigns(:inputs).should   === ['name']
        assigns(:meta).should     === []
        assigns(:buttons).should  === ['browse_products']
        assigns(:parts).should    === ['description','products']
        assigns(:popups).should   === ['browse_products']
      end
    end
  end
  
end