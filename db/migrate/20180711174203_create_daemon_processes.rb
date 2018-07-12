class CreateDaemonProcesses < ActiveRecord::Migration[5.1]
  def change
    create_table :daemon_processes do |t|
      t.integer :pid
      t.string :name

      t.timestamps
    end
  end
end
