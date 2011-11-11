desc "Run guard"
task :guard do
  sh %{bundle exec guard start}
end