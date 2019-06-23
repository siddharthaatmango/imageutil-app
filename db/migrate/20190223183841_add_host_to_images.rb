class AddHostToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :host_domain, :string, default: "transform.imageutil.io"
    add_column :projects, :default_host_domain, :string, default: "transform.imageutil.io"
  end
end
