class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :start]

  def home
  end

  def start
    require 'pty'
    require 'open3'
    $stdout.sync = true
    filepath = File.expand_path('app/lib/action.rb')
    puts PTY.spawn("ruby '#{filepath}'")
    puts "after PTY"
    render :home
  end

end
