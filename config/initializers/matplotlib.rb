mpl_config_dir = Rails.root.join('tmp', 'matplotlib')
FileUtils.mkdir_p(mpl_config_dir) unless File.exist?(mpl_config_dir)
