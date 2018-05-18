  module CompanyName
    def set_company_name(name)
      @company_name = name
    end

    def get_company_name
      @company_name
    end

    protected
    attr_accessor :company_name
  end
