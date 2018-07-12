class DaemonProcessesController < ApplicationController
  before_action :set_daemon_process, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!
  # GET /daemon_processes
  # GET /daemon_processes.json
  def index
    @daemon_processes = DaemonProcess.all
    @daemon_process = DaemonProcess.new
  end

  # GET /daemon_processes/1
  # GET /daemon_processes/1.json
  def show
  end

  # GET /daemon_processes/new
  def new
    @daemon_process = DaemonProcess.new
  end

  # GET /daemon_processes/1/edit
  def edit
  end

  # POST /daemon_processes
  # POST /daemon_processes.json
  def create
    # require 'pty'
    # require 'open3'
    # $stdout.sync = true
    puts "Parent pid: #{Process.pid}. pgid: #{Process.getpgrp}"
    filepath = File.expand_path('app/lib/action.rb')
    # reader, writer, pid = PTY.spawn("ruby '#{filepath}'")
    child_pid = fork do
      Signal.trap("SIGTERM") { puts "Ouch!"; exit }
      puts "Child pid: #{Process.pid}, pgid: #{Process.getpgrp}"
      Process.setsid
      puts "Child new pgid: #{Process.getpgrp}"
      puts "Child: long operation..."
      system "sleep 20"
    end
    sleep 2
    pgid = Process.getpgid(child_pid)
    puts "Child process pgid : #{pgid}"
    @daemon_process = DaemonProcess.new(pid: pgid, name: "process_#{Time.now.to_i.to_s}")

    respond_to do |format|
      if @daemon_process.save
        format.html { redirect_to @daemon_process, notice: "Daemon process was successfully started : #{pgid}" }
        format.json { render :show, status: :created, location: @daemon_process }
      else
        format.html { render :index }
        format.json { render json: @daemon_process.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /daemon_processes/1
  # PATCH/PUT /daemon_processes/1.json
  def update
    respond_to do |format|
      if @daemon_process.update(daemon_process_params)
        format.html { redirect_to @daemon_process, notice: 'Daemon process was successfully updated.' }
        format.json { render :show, status: :ok, location: @daemon_process }
      else
        format.html { render :edit }
        format.json { render json: @daemon_process.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /daemon_processes/1
  # DELETE /daemon_processes/1.json
  def destroy
    pgid = @daemon_process.pid
    begin
      puts "Sending SIGTERM to group #{pgid}..."
      Process.kill('SIGTERM', -pgid)
      Process.detach(pgid)
      puts "Process killed..."
    rescue Exception => error
      puts "Error : #{error}"
    end
    puts "Deleting process from database records"
    @daemon_process.destroy
    respond_to do |format|
      format.html { redirect_to daemon_processes_url, notice: 'Daemon process was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daemon_process
      @daemon_process = DaemonProcess.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def daemon_process_params
      params.require(:daemon_process).permit(:pid, :name)
    end
end
