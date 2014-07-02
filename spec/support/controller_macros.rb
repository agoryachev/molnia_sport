# encoding: utf-8
module ControllerMacros

  def login_employee
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:employee]
      employee = Factory.create(:employee)
      # or set a confirmed_at inside the factory. Only necessary if you
      # are using the confirmable module
      employee.skip_confirmation!
      employee.group = employee_group
      employee.save!
      sign_in employee
    end
  end

  def stub_employee_abilities(skip = false)        
    controller.stub(:check_employee_abilities!).and_return(true) unless skip
  end

end