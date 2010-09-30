require 'spec/spec_helper'

describe Admin::Shop::OrdersController do
  
  dataset :shop_orders, :users
  
  before(:each) do
    login_as  :admin
  end
  
  describe '#edit' do
    context 'instance variables' do
      context 'order with no address or customer' do
        it 'should assign the following' do
          get :edit, :id => shop_orders(:empty).id
          
          assigns(:inputs).should   === []
          assigns(:meta).should     === []
          assigns(:buttons).should  === []
          assigns(:parts).should    === ['items']
          assigns(:popups).should   === []
        end
      end
      context 'order with no address and customer' do
        it 'should assign the following' do
          get :edit, :id => shop_orders(:one_item).id
          
          assigns(:inputs).should   === []
          assigns(:meta).should     === []
          assigns(:buttons).should  === []
          assigns(:parts).should    === ['items','customer']
          assigns(:popups).should   === []
        end
      end
      context 'order with no address and customer' do
        it 'should assign the following' do
          get :edit, :id => shop_orders(:several_items).id
          
          assigns(:inputs).should   === []
          assigns(:meta).should     === []
          assigns(:buttons).should  === []
          assigns(:parts).should    === ['items','addresses','customer']
          assigns(:popups).should   === []
        end
      end
    end
  end
  
  describe '#update' do
    context 'order with no address or customer' do
      it 'should assign the following' do
        put :update, :id => shop_orders(:empty).id, :shop_order => {}
        
        assigns(:inputs).should   === []
        assigns(:meta).should     === []
        assigns(:buttons).should  === []
        assigns(:parts).should    === ['items']
        assigns(:popups).should   === []
      end
    end
    context 'order with no address and customer' do
      it 'should assign the following' do
        put :update, :id => shop_orders(:one_item).id, :shop_order => {}
        
        assigns(:inputs).should   === []
        assigns(:meta).should     === []
        assigns(:buttons).should  === []
        assigns(:parts).should    === ['items','customer']
        assigns(:popups).should   === []
      end
    end
    context 'order with no address and customer' do
      it 'should assign the following' do
        put :update, :id => shop_orders(:several_items).id, :shop_order => {}
        
        assigns(:inputs).should   === []
        assigns(:meta).should     === []
        assigns(:buttons).should  === []
        assigns(:parts).should    === ['items','addresses','customer']
        assigns(:popups).should   === []
      end
    end
  end
  
end