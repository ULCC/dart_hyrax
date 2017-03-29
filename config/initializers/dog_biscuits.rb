# load dog_biscuits config
DOGBISCUITS = YAML.load(File.read(File.expand_path('../../dog_biscuits.yml', __FILE__))).with_indifferent_access
# include Terms
Qa::Authorities::Local.register_subauthority('projects', 'DogBiscuits::Terms::ProjectTerms')
Qa::Authorities::Local.register_subauthority('current_organisations', 'DogBiscuits::Terms::CurrentOrganisationTerms')
Qa::Authorities::Local.register_subauthority('current_persons', 'DogBiscuits::Terms::CurrentPersonTerms')
Qa::Authorities::Local.register_subauthority('departments', 'DogBiscuits::Terms::DepartmentTerms')