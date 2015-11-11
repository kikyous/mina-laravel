# ### asset_paths
# The paths to be checked.
#
# Whenever assets are compiled, the asset files are checked if they have
# changed from the previous release.
#
# If they're unchanged, compiled assets will simply be copied over to the new
# release.
#
# Override this if you have custom asset paths

set_default :asset_paths, ['resources/assets/']

# ### compiled_asset_path
# The path to be copied to the new release.
#
# The path your assets are compiled to. If your `assets_path` assets have changed,
# this is the folder that gets copied accross from the current release to the new release.
#
# Override this if you have custom public asset paths.

set_default :compiled_asset_path, 'public/build'

# ### rake_assets_precompile
# The command to invoke when precompiling assets.
# Override me if you like.

settings.cmd_assets_build ||= lambda { 'gulp --production' }

def check_for_changes_script(options={})
  diffs = options[:at].map { |path|
    %[diff -rN "#{deploy_to}/#{current_path}/#{path}" "./#{path}" 2>/dev/null]
  }.join("\n")

  unindent %[
    if [ -e "#{deploy_to}/#{current_path}/#{options[:check]}" ]; then
      count=`(
        #{reindent 4, diffs}
      ) | wc -l`
      if [ "$((count))" = "0" ]; then
        #{reindent 4, options[:skip]} &&
        exit
      else
        #{reindent 4, options[:changed]}
      fi
    else
      #{reindent 2, options[:default]}
    fi
  ]
end

# ### log
# Tail log from server
#
#     $ mina log

desc "Tail log from server"
task :log => :environment do
  queue %[tail -f #{deploy_to}/#{current_path}/storage/logs/laravel.log]
end

namespace :laravel do
  # ### gulp --production
  desc "build assets (skips if nothing has changed since the last release)."
  task :'build_assets' do
    if ENV['force_assets']
      invoke :'laravel:build_assets:force'
    else
      message = verbose_mode? ?
        '$((count)) changes found, building asset files' :
        'Building asset files'

      queue check_for_changes_script \
        :check => compiled_asset_path,
        :at => [*asset_paths],
        :skip => %[
          echo "-----> Skipping build asset"
          #{echo_cmd %[mkdir -p "#{deploy_to}/$build_path/#{compiled_asset_path}"]}
          #{echo_cmd %[cp -R "#{deploy_to}/#{current_path}/#{compiled_asset_path}/." "#{deploy_to}/$build_path/#{compiled_asset_path}"]}
        ],
        :changed => %[
          echo "-----> #{message}"
          #{echo_cmd %[#{cmd_assets_build}]}
        ],
        :default => %[
          echo "-----> Building asset files"
          #{echo_cmd %[#{cmd_assets_build}]}
        ]
    end
  end
  # ### laravel:build_assets:force
  desc "Build assets."
  task :'build_assets:force' do
    queue %{
      echo "-----> Building asset files"
      #{echo_cmd %[#{cmd_assets_build}]}
    }
  end
end
