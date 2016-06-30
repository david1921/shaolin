require 'paf'

namespace :post_zones do
  desc "Recreate the post-zone database by importing PAF compressed standard files"
  task :recreate => :environment do
    paths = ENV["PATHS"].to_s.split(" ")
    raise "Must set PATHS to the path of at least one PAF file" unless paths.present?

    $stderr.puts "Deleting all post-zone records"
    PostZone.delete_all

    paths.each do |path|
      $stderr.puts "Importing PAF file #{path}"
      Paf::CompressedStandardFile.new(path).with_each_post_code do |post_code, post_town, records|
        unless post_code.blank? || post_town.blank? || records.empty?
          PostZone.create!(:post_code => post_code, :post_town => post_town, :records => records)
        else
          $stderr.puts "Skipping PAF records #{[post_code, post_town, records].inspect}"
        end
      end
    end
  end
end
