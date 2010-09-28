class FormsDataset < Dataset::Base
  
  uses :pages, :shop_orders
  
  def load
    create_record :form, :checkout, 
      :title    => 'Checkout',
      :body     => body,
      :content  => content,
      :config   => config
  end
  
  def body
<<-BODY
<r:shop:cart>
  <div class="addresses">
    <ol class="billing">
      <li>
        <r:label for='billing[name]'>Name</r:label>
        <r:text name='billing[name]' />
      </li>
      <li>
        <r:label for='billing[unit]'>Address</r:label>
        <r:text name='billing[unit]' /> <r:text name='billing[street]' /> <r:text name='billing[suburb]' />
      </li>
      <li>
        <r:label for='billing[state]'>State and Country</r:label>
        <r:text name='billing[state]' /> <r:text name='billing[country]' />
      </li>
      <li>
        <r:label for='billing[postcode]'>Postcode</r:label>
        <r:text name='billing[postcode]' />
      </li>
    </ol>
  </div>
  <ol class="card">
    <li>
      <r:label for='card[name]'>Name on Card</r:label>
      <r:text name='card[name]' />
    </li>
    <li>
      <r:label for='card[number]'>Card</r:label>
      <r:card:type /> <r:text name='card[number]' /> <r:text name='card[verification]' length='4' />
      <r:card:month /> <r:card:year />
    </li>
  </ol>
  <r:form:submit />
</r:shop:cart>
BODY
  end
  
  def content
<<-CONTENT
    
CONTENT
  end
  
  def config
<<-CONFIG
checkout:
  test: true
  gateway:
    name: Bogus
    credentials:
      login: 123456
CONFIG
  end
  
  helpers do
    def mock_page_with_request_and_data
      @page     = pages(:home)
      
      @request  = OpenStruct.new({
        :session => {}
      })
      @data     = {}
      
      stub(@page).data    { @data }
      stub(@page).request { @request }
    end
    
    def mock_response
      @response = OpenStruct.new({
        :result => {
          :results => {}
        }
      })
      mock(Forms::Tags::Responses).current(anything,anything) { @response }
    end
    
    def valid_form_checkout_request_and_response
      login_as :customer
      
      form   = forms(:checkout)
      order  = shop_orders(:several_items)
      
      form[:extensions] = {
        :checkout   => {
          :test     => true,
          :gateway  => {
            :name   => 'Bogus'
          }
        }
      }
      
      mock.instance_of(ActiveMerchant::Billing::CreditCard).valid? { true }
      
      @data = {
        :card => { 
          :number       => '1',
          :name         => 'Mr. Joe Bloggs',
          :verification => '123',
          :month        => 1,
          :year         => 2012,
          :type         => 'visa'
        },
        :billing => {
          :id           => shop_addresses(:billing).id
        },
        :shipping => {
          :id           => shop_addresses(:shipping).id
        },
        :options => {
          :address => {
            :address1     => 'address',
            :zip          => 'zip'
          }
        }
      }
      
      @request.session = { :shop_order => order.id }
      
      @checkout = FormCheckout.new(form, @page)
    end
  end
  
end