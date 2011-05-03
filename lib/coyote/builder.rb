module Coyote
  class Builder

		attr_accessor :config, :options

		def initialize(options)
			@options = options
			@config = get_config_or_screw_off
		end
		
		def build
			if @config && config_defined?
				@config.each do |key,value|
					input_files = value['files']
					output_filename = value['output']
					output = Coyote::Output.new output_filename
			
					input_files.each do |filename|
						output.append(filename)
					end

					if value['compress'] || @options[:compress]
						output.compress
					end

					output.save
				end
			else
				print "Coyote configuration exists but has not been defined yet. Configure it in #{Coyote::CONFIG_FILENAME}\n".red
			end
		end


		def get_config_or_screw_off
			if File.exists?(Coyote::CONFIG_FILENAME)
				begin
				  return YAML.load(File.open(Coyote::CONFIG_FILENAME))
				rescue ArgumentError => e
				  print "Could not parse YAML: #{e.message}\n".red
				  return false
				end
			else
				print "Could not find a Coyote configuration file in this directory. Use 'coyote generate' to create one.\n".red
				exit
			end
		end
		
		def config_defined?
			@config.class == Hash && ! @config.empty?
		end
  end
end