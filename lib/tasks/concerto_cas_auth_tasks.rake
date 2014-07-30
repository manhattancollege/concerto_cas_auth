namespace :concerto_cas_auth do
	desc "Copy CAS configuration to core Concerto application"
	task :install do
		source = File.join(Gem.loaded_specs["concerto_cas_auth"].full_gem_path, "config", "concerto_cas_auth.yml.sample")
		target = File.join(Rails.root, "config", "initializers", "concerto_cas_auth.yml")
		FileUtils.cp_r source, target
	end
end