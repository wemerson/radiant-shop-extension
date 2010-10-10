require 'spec/spec_helper'

describe Admin::Shop::DiscountsController do
  
  dataset :users, :shop_discounts
  
  before(:each) do
    login_as  :admin
  end
  
  describe 'index' do
    context 'instance variables' do
      it 'should be assigned' do
        get :index
        
        assigns(:inputs).should   === []
        assigns(:meta).should     === []
        assigns(:buttons).should  === ['packages','variants','discounts']
        assigns(:parts).should    === []
        assigns(:popups).should   === []
      end
    end
  end
  
  describe '#new' do
    context 'instance variables' do
      it 'should be assigned' do
        get :new
        
        assigns(:inputs).should   === ['name','amount','code']
        assigns(:meta).should     === ['start','end']
        assigns(:buttons).should  === []
        assigns(:parts).should    === ['categories']
        assigns(:popups).should   === []
      end
    end
  end
  
  describe '#edit' do
    context 'instance variables' do
      it 'should be assigned' do
        get :edit, :id => shop_discounts(:ten_percent).id
        
        assigns(:inputs).should   === ['name','amount','code']
        assigns(:meta).should     === ['start','end']
        assigns(:buttons).should  === []
        assigns(:parts).should    === ['categories']
        assigns(:popups).should   === []
      end
    end
  end
  
  describe '#create' do
    context 'instance variables' do
      it 'should be assigned' do
        post :create, :shop_variant => {}
        
        assigns(:inputs).should   === ['name','amount','code']
        assigns(:meta).should     === ['start','end']
        assigns(:buttons).should  === []
        assigns(:parts).should    === ['categories']
        assigns(:popups).should   === []
      end
    end
  end
  
  describe '#update' do
    context 'instance variables' do
      it 'should be assigned' do
        put :update, :id => shop_discounts(:ten_percent).id, :shop_variant => {}
        
        assigns(:inputs).should   === ['name','amount','code']
        assigns(:meta).should     === ['start','end']
        assigns(:buttons).should  === []
        assigns(:parts).should    === ['categories']
        assigns(:popups).should   === []
      end
    end
  end
  
end