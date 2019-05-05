class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_many :folders
  # belongs_to :folder

  validates :name, presence: true
  validates :user, presence: true
  validates :project, presence: true

  validates :name, uniqueness: { case_sensitive: false, scope: [:user_id, :project_id, :folder_id], message: "is already created" }

  before_save :set_path

  def tokenize
    token = "#{self.user_id}_#{self.project_id}_#{SecureRandom.hex(4)}_#{(DateTime.now + 1.hour).to_i}"
    self.update_columns({upload_token: token})
    token
  end
  def upload_host
    Rails.env.production? ? 'https://imagetransform.io' : 'http://127.0.0.1:9090'
  end

  def self.get_node(project_id, folder_id)
    r = []
    folders = Folder.where(project_id: project_id, folder_id: folder_id)
    folders.each do |f|
      r << {
        id: f.id,
        text: f.name,
        icon: f.is_file ? "jstree-file" : "jstree-folder",
        li_attr: {
          parent_id: f.folder_id,
          can_add_file: f.is_file ? false : true,
          can_add_folder: f.is_file ? false : true,
        },
        state:{
          opened: false,
          selected: false,
          disabled: false
        },
        children: Folder.where(project_id: project_id, folder_id: f.id).any?
      }
    end
    r
  end

  def self.root_node(projects)
    h = []
    projects.each do |prj|
      h << {
        id: 'ROOT',
        text: prj.name,
        li_attr: {
          parent_id: "",
          can_add_file: false,
          can_add_folder: false,
        },
        state:{
          opened: true,
          selected: false,
          disabled: true
        },
        children: [
          {
              id: 'OTF',
              text: 'On The Fly',
              li_attr: {
                parent_id: "",
                can_add_file: false,
                can_add_folder: false,
              },
              state:{
                opened: false,
                selected: false,
                disabled: true
              },
              children: false
          },
          {
              id: 'M',
              text: 'Media',
              li_attr: {
                parent_id: "",
                can_add_file: false,
                can_add_folder: true,
              },
              state:{
                opened: true,
                selected: false,
                disabled: false
              },
              children: Folder.get_node(prj.id, nil)
          }
        ]
      }.to_dot
    end
    h
  end


  private
    def set_path
        unless self.is_file
          self.path = "#{self.user_id}/#{self.project_id}/#{self.name.gsub(/\W/, '_').downcase}"
          parent = Folder.find_by_id(self.folder_id) if self.folder_id
          self.path = "#{parent.path}/#{self.name.gsub(/\W/, '_').downcase}" if parent
        end
    end
end
