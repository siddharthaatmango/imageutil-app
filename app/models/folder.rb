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
          is_readonly: false,
          can_add: true,
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
          is_readonly: true,
          can_add: false,
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
                is_readonly: true,
                can_add: false,
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
                is_readonly: true,
                can_add: true,
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
        self.path = self.name.gsub(/\W/, '_')
        parent = Folder.find_by_id(self.folder_id) if self.folder_id
        self.path = "#{parent.path}/#{self.path}" if parent
    end
end
