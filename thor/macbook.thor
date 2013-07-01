Thor::Util.load_thorfile(File.expand_path('macbook_provision.thor', File.dirname(__FILE__)))

class Macbook < MacbookProvision

  def initialize *args
    @config = read_node("thor/rat_node.json")

    super
  end

  desc "all", "Installs all required packages"
  def all
    super.all

    invoke :mysql_create
    invoke :postgres_create
  end

  desc "mysql_create", "Initializes mysql project schemas"
  def mysql_create
    create_mysql_user "rails_app_tmpl"

    create_mysql_schema "rails_app_tmpl_test"
    create_mysql_schema "rails_app_tmpl_dev"
    create_mysql_schema "rails_app_tmpl_prod"
  end

  desc "postgres_create", "Initializes postgres project schemas"
  def postgres_create
    create_postgres_user "rails_app_tmpl", "rails_app_tmpl_test"

    create_postgres_schema "rails_app_tmpl", "rails_app_tmpl_test"
    create_postgres_schema "rails_app_tmpl", "rails_app_tmpl_dev"
    create_postgres_schema "rails_app_tmpl", "rails_app_tmpl_prod"
  end

  desc "postgres_drop", "Drops postgres project schemas"
  def postgres_drop
    drop_postgres_schema "rails_app_tmpl_test"
    drop_postgres_schema "rails_app_tmpl_dev"
    drop_postgres_schema "rails_app_tmpl_prod"

    drop_postgres_user "rails_app_tmpl", "rails_app_tmpl_test"
  end

  desc "mysql_test", "Test mysql schemas"
  def mysql_test
    result = get_mysql_schemas config[:mysql][:hostname], config[:mysql][:user], config[:mysql][:password], "rails_app_tmpl_test"

    puts result
  end

  desc "postgres_test", "Test postgres schemas"
  def postgres_test
    result = get_postgres_schemas "rails_app_tmpl_test"

    puts result
  end

end

