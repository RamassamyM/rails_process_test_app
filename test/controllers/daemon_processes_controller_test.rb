require 'test_helper'

class DaemonProcessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @daemon_process = daemon_processes(:one)
  end

  test "should get index" do
    get daemon_processes_url
    assert_response :success
  end

  test "should get new" do
    get new_daemon_process_url
    assert_response :success
  end

  test "should create daemon_process" do
    assert_difference('DaemonProcess.count') do
      post daemon_processes_url, params: { daemon_process: { name: @daemon_process.name, pid: @daemon_process.pid } }
    end

    assert_redirected_to daemon_process_url(DaemonProcess.last)
  end

  test "should show daemon_process" do
    get daemon_process_url(@daemon_process)
    assert_response :success
  end

  test "should get edit" do
    get edit_daemon_process_url(@daemon_process)
    assert_response :success
  end

  test "should update daemon_process" do
    patch daemon_process_url(@daemon_process), params: { daemon_process: { name: @daemon_process.name, pid: @daemon_process.pid } }
    assert_redirected_to daemon_process_url(@daemon_process)
  end

  test "should destroy daemon_process" do
    assert_difference('DaemonProcess.count', -1) do
      delete daemon_process_url(@daemon_process)
    end

    assert_redirected_to daemon_processes_url
  end
end
