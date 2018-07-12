class DaemonProcess < ApplicationRecord
  validates :pid, presence: true

  def is_running?
    Process.kill(0, pid.to_i)
    true
  rescue Errno::ESRCH # No such process
    false
  rescue Errno::EPERM # The process exists, but you dont have permission to send the signal to it.
    'zombie'
  end
end
