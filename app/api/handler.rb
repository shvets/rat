module Handler

  def generate_error error_type, errors
    { :exception =>
        { :type => error_type,
          :errors => errors
        }
    }
  end

  def create_errors group
    {group => {}}
  end

  def active_model_errors_to_errors group, errors, active_model_errors
    active_model_errors.each do |key, value|
      errors[group] = { key => value }
    end

    errors
  end

end
