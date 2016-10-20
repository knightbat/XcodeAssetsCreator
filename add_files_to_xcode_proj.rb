#!/usr/local/bin/ruby -w

require 'xcodeproj'
require 'find'

project_file_paths = []
Find.find('output') do |path|
  project_file_paths << path if path =~ /.*\.xcodeproj$/
end

project = Xcodeproj::Project.open(project_file_paths[0])

main_group = project.main_group['AMV']
user_target_uuid = project.targets[0].uuid
var_group = main_group.new_variant_group('Localizable.strings')

new_file_array = []

ARGV.each do |lang|
    puts lang
    file_ref = var_group.new_file("#{lang}.lproj/Localizable.strings")
    new_file_array << file_ref
end

target = project.objects_by_uuid[user_target_uuid]
target.add_resources(new_file_array)

project.save
